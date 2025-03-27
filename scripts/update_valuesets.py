import base64
import csv
import json
import re
from pathlib import Path
from tqdm import tqdm
import pandas as pd
import requests
import copy

# Replace with your VSAC API key
API_KEY = "apikey:ef6477ff-c9dc-4f5a-99f6-0048ddffc516"
encoded_api_key = base64.b64encode(API_KEY.encode()).decode()

# Define the base URL for VSAC API
VSAC_URL = "https://vsac.nlm.nih.gov/vsac/svs"

VALUESET_PATH = "/Users/matt/dev/recoverx/ecqm-content-qicore-2024/input/vocabulary/valueset/external"

# Function to fetch value set concepts from VSAC
def fetch_value_set(value_set_oid):
    """
    Fetches the concepts of a value set from VSAC using the VSAC API.

    :param value_set_oid: OID of the value set.
    :return: A list of dictionaries containing code and description of the concepts.
    """
    # API endpoint for value set retrieval
    headers = {"Authorization": f"Basic {encoded_api_key}"}
    result = None
    next_offset = 0
    while result is None or next_offset is not None:
        # Make the GET request to fetch the value set
        endpoint = f"https://cts.nlm.nih.gov/fhir/res/ValueSet/{value_set_oid}/$expand?_format=json&offset={next_offset}"
        response = requests.get(endpoint, headers=headers)

        if response.status_code == 200:
            data = response.json()
            next_offset = extract_next_offset(data)
            result = combine_data(result, data)
        else:
            raise(f"Failed to fetch value set: {response.status_code} - {response.text}")
    if 'expansion' not in result or 'contains' not in result['expansion'] or len(result['expansion']['contains']) != result['expansion']['total']:
        print('Failed to fetch all value set concepts')
        return None
    del result['expansion']['parameter']
    return result

def extract_next_offset(data):
    total = data.get('expansion', {}).get("total", 0)
    offset = data.get('expansion', {}).get("offset", 0)
    offset_2 = next((i.get('valueInteger') for i in data.get('expansion', {}).get("parameter", []) if i.get("name") == "offset"), None)
    count = next((i.get('valueInteger') for i in data.get('expansion', {}).get("parameter", []) if i.get("name") == "count"), None) 
    if count + offset < total:
        return count + offset
    return None
def combine_data(result, data):
    if result is None:
        return data
    result['expansion']['contains'] += data['expansion']['contains']
    return result

# Function to write concepts to CSV
def write_concepts_to_csv(concepts, output_file):
    """
    Writes the value set concepts to a CSV file.

    :param concepts: List of dictionaries containing code and description.
    :param output_file: Path to the output CSV file.
    """
    with open(output_file, mode="w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(["Code", "Display Name", "System"])  # CSV header

        for concept in concepts:
            writer.writerow([concept["code"], concept["display"], concept["system"]])


def vsac_valueset_files(path: str):
    # Specify the directory
    directory = Path(path)
    # List all files in the directory
    files = [file.name for file in directory.iterdir() if file.is_file()]
    files = [f for f in files if re.match(r"^valueset-\d+\..*\.json$", f)]
    oids = [re.match(r"^valueset-(\d+\..*)\.json$", f).group(1) for f in files]
    # Print the list of files
    return files


def split_large_valueset(valueset_json, value_set_oid, chunk_size=999):
    """
    Splits a large valueset into smaller chunks with updated IDs.

    :param valueset_json: The original valueset JSON.
    :param value_set_oid: The OID of the valueset.
    :param chunk_size: Maximum number of concepts per chunk.
    :return: List of valueset JSONs, each containing a subset of concepts.
    """
    if not valueset_json or 'expansion' not in valueset_json or 'contains' not in valueset_json['expansion']:
        return [valueset_json]

    # Get the total number of concepts
    total_concepts = len(valueset_json['expansion']['contains'])

    # If the total is less than or equal to the chunk size, return the original
    if total_concepts <= chunk_size:
        return [valueset_json]

    # Calculate the number of chunks needed
    num_chunks = (total_concepts + chunk_size - 1) // chunk_size

    # Create a list to store the split valuesets
    split_valuesets = []

    # Divide the concepts into chunks
    for i in range(num_chunks):
        # Create a deep copy of the original valueset
        chunk_valueset = copy.deepcopy(valueset_json)

        # Create new ID for this chunk (add .1, .2, .3, etc.)
        new_id = f"{value_set_oid}.{i+1}"

        # Update the valueset ID and related fields
        chunk_valueset['id'] = new_id

        # Update URL if present
        if 'url' in chunk_valueset:
            chunk_valueset['url'] = f"http://cts.nlm.nih.gov/fhir/ValueSet/{new_id}"

        # Update identifier if present
        if 'identifier' in chunk_valueset:
            for identifier in chunk_valueset['identifier']:
                if identifier.get('system') == 'urn:ietf:rfc:3986' and identifier.get('value', '').startswith('urn:oid:'):
                    identifier['value'] = f"urn:oid:{new_id}"

        # Update name and title if desired (optional)
        if 'name' in chunk_valueset:
            chunk_valueset['name'] = f"{chunk_valueset['name']}Part{i+1}"
        if 'title' in chunk_valueset:
            chunk_valueset['title'] = f"{chunk_valueset['title']} - Part {i+1}"

        # Update expansion identifier
        if 'expansion' in chunk_valueset and 'identifier' in chunk_valueset['expansion']:
            import uuid
            chunk_valueset['expansion']['identifier'] = f"urn:uuid:{uuid.uuid4()}"

        # Calculate the start and end indices for this chunk
        start_idx = i * chunk_size
        end_idx = min((i + 1) * chunk_size, total_concepts)

        # Replace the 'contains' array with the subset for this chunk
        chunk_valueset['expansion']['contains'] = valueset_json['expansion']['contains'][start_idx:end_idx]

        # Update the total count in the expansion
        chunk_valueset['expansion']['total'] = end_idx - start_idx

        # Add the chunk to the list
        split_valuesets.append(chunk_valueset)

    return split_valuesets


# Main function to fetch and write value set concepts to a CSV
def main():
    files = vsac_valueset_files(VALUESET_PATH)

    # Specify the OID of the large valueset
    large_valueset_oid = "2.16.840.1.113883.3.464.1003.102.12.1025"

    # Fetch the value set concepts
    for file in tqdm(files):
        value_set_oid = re.match(r"^valueset-(\d+\..*)\.json$", file).group(1)
        valueset_json = fetch_value_set(value_set_oid)
        if value_set_oid == large_valueset_oid:
            # Split the large valueset into smaller chunks
            split_valuesets = split_large_valueset(valueset_json, value_set_oid)
            # Write each chunk to a separate file
            for i, chunk_valueset in enumerate(split_valuesets):
                # Get the new ID that includes the part number
                new_id = f"{large_valueset_oid}.{i+1}"
                # Create a filename for this chunk
                chunk_file = f"valueset-{new_id}.json"
                output_file = f"{VALUESET_PATH}/{chunk_file}"

                # Write the chunk to a file
                with open(output_file, "w", encoding="utf-8") as f:
                    json.dump(chunk_valueset, f, indent=2)
                    print(f"Valueset chunk {i+1}/{len(split_valuesets)} written to {output_file}")
            continue

        if valueset_json:
            # Write the JSON data to a file
            print(f"Value set data fetched for {file}. Concepts: {len(valueset_json['expansion']['contains'])}")
            output_file = f"{VALUESET_PATH}/{file}"
            with open(output_file, "w", encoding="utf-8") as f:
                json.dump(valueset_json, f, indent=2)
                print(f"Value set data written to {output_file}")
        else:
            print(f"No data to write for value_set {file}.")


if __name__ == "__main__":
    main()
