"""
FHIR ValueSet Analyzer

This script queries a FHIR server for specified ValueSets and analyzes their code systems.
It determines which code systems (CPT, SNOMED, etc.) are present in each ValueSet and
generates a detailed report.

Usage:
    python fhir_valueset_analyzer.py --config config.json
    python fhir_valueset_analyzer.py --server "http://fhir-server-url" --output results.json
"""
import requests
import json
from urllib.parse import quote
import time

# Define the ValueSets to query
valuesets = {
    "Annual Wellness Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1240',
    "Audiology Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1066',
    "Care Services in Long Term Residential Facility": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1014',
    "Discharge Services Nursing Facility": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1013',
    "Falls Screening": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.118.12.1028',
    "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016',
    "Nursing Facility Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1012',
    "Occupational Therapy Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1011',
    "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001',
    "Ophthalmological Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1285',
    "Physical Therapy Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1022',
    "Preventive Care Services Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1025',
    "Preventive Care Services Individual Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1026',
    "Preventive Care Services Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1023',
    "Telephone Visits": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1080',
    "Virtual Encounter": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1089'
}

# Map system URLs to more readable names
system_mapping = {
    "http://snomed.info/sct": "SNOMED",
    "http://www.ama-assn.org/go/cpt": "CPT",
    "http://www.nlm.nih.gov/research/umls/hcpcs": "HCPCS",
    "http://loinc.org": "LOINC",
    "http://hl7.org/fhir/sid/icd-10-cm": "ICD-10-CM",
    "http://hl7.org/fhir/sid/icd-9-cm": "ICD-9-CM"
}

def get_valueset_details(base_url, valueset_url):
    """
    Fetch a ValueSet from the FHIR server and analyze its code systems
    """
    # Extract the ValueSet ID from the URL
    valueset_id = valueset_url.split('/')[-1]
    
    # URL encode the ID to handle special characters
    encoded_id = quote(valueset_id)
    
    # Construct the full API URL
    api_url = f"{base_url}/ValueSet/{encoded_id}"
    
    try:
        # Make the GET request
        response = requests.get(api_url, headers={"Accept": "application/fhir+json"})
        response.raise_for_status()  # Raise exception for non-2xx responses
        
        # Parse the JSON response
        data = response.json()
        
        # Extract code systems
        systems = set()
        
        # Check if compose and include exist in the response
        if "compose" in data and "include" in data["compose"]:
            for include in data["compose"]["include"]:
                if "system" in include:
                    system_url = include["system"]
                    # Map the system URL to a readable name
                    system_name = system_mapping.get(system_url, system_url)
                    systems.add(system_name)
        
        # Determine the type of codes
        if len(systems) == 0:
            code_type = "No systems found"
        elif "SNOMED" in systems and "CPT" in systems:
            code_type = "Both SNOMED and CPT"
        elif "SNOMED" in systems:
            code_type = "SNOMED only"
        elif "CPT" in systems:
            code_type = "CPT only"
        else:
            code_type = "Other: " + ", ".join(systems)
        
        # Count the number of codes
        code_count = 0
        if "compose" in data and "include" in data["compose"]:
            for include in data["compose"]["include"]:
                if "concept" in include:
                    code_count += len(include["concept"])
        
        return {
            "id": valueset_id,
            "name": data.get("name", "Unnamed"),
            "title": data.get("title", "Untitled"),
            "code_systems": list(systems),
            "code_type": code_type,
            "code_count": code_count
        }
    
    except requests.exceptions.HTTPError as e:
        return {
            "id": valueset_id,
            "error": f"HTTP Error: {e}"
        }
    except requests.exceptions.RequestException as e:
        return {
            "id": valueset_id,
            "error": f"Request Error: {e}"
        }
    except json.JSONDecodeError:
        return {
            "id": valueset_id,
            "error": "Invalid JSON response"
        }
    except Exception as e:
        return {
            "id": valueset_id,
            "error": f"Unexpected error: {e}"
        }

def main():
    fhir_base_url = "http://localhost:8089/fhir"
    
    # Results storage
    results = []
    
    # Process each ValueSet
    print(f"Fetching data for {len(valuesets)} ValueSets...")
    for idx, (name, url) in enumerate(valuesets.items(), 1):
        print(f"[{idx}/{len(valuesets)}] Processing: {name}")
        
        # Get the ValueSet details
        details = get_valueset_details(fhir_base_url, url)
        details["name_in_list"] = name
        results.append(details)
        
        # Add a small delay to avoid overwhelming the server
        time.sleep(0.5)
    
    # Print the results in a table format
    print("\n" + "="*200)
    print(f"{'ValueSet Name':<100} | {'Code Systems':<75} | {'Code Count':<10}")
    print("-"*200)
    
    for result in results:
        if "error" in result:
            print(f"{result['name_in_list']:<100} | ERROR: {result['error']}")
        else:
            systems = ", ".join(result["code_systems"])
            print(f"{result['name_in_list']:<100} | {systems:<75} | {result['code_count']:<10}")
    
    # Save results to a JSON file
    with open("valueset_analysis.json", "w") as f:
        json.dump(results, f, indent=2)
    
    print("\nResults saved to valueset_analysis.json")

if __name__ == "__main__":
    main()