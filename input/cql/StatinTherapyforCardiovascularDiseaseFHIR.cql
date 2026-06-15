library StatinTherapyforCardiovascularDiseaseFHIR version '0.2.000'

using QICore version '4.1.1'

include FHIRHelpers version '4.3.000' called FHIRHelpers
include Hospice version '6.9.000' called Hospice
include PalliativeCare version '1.9.000' called PalliativeCare
include QICoreCommon version '2.0.000' called QICoreCommon
include SupplementalDataElements version '3.4.000' called SDE
include Status version '1.6.000' called Status

codesystem "CPT": 'http://www.ama-assn.org/go/cpt'
codesystem "LOINC": 'http://loinc.org'
codesystem "ObservationCategoryCodes": 'http://terminology.hl7.org/CodeSystem/observation-category'
codesystem "RxNorm": 'https://www.nlm.nih.gov/research/umls/rxnorm/index.html'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "HCPCS": 'http://www.nlm.nih.gov/research/umls/hcpcs'
codesystem "Cerner6000": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/6000'

valueset "Annual Wellness Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1240'
valueset "Atherosclerosis and Peripheral Arterial Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1047.21'
valueset "Breastfeeding": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1047.73'
valueset "CABG Surgeries": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.694'
valueset "CABG or PCI Procedure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1138.566'
valueset "Carotid Intervention": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.204'
valueset "Cerebrovascular Disease Stroke or TIA": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1047.44'
valueset "Diabetes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.103.12.1001'
valueset "End Stage Renal Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.353'
valueset "Familial Hypercholesterolemia": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1047.100'
valueset "Hepatitis A": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1024'
valueset "Hepatitis B": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.67.1.101.1.269'
valueset "High Intensity Statin Therapy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1572'
valueset "Ischemic Heart Disease or Other Related Diagnoses": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1047.46'
valueset "LDL Cholesterol": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1573'
valueset "Liver Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1047.42'
valueset "Low Intensity Statin Therapy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1574'
valueset "Medical Reason": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1007'
valueset "Moderate Intensity Statin Therapy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1575'
valueset "Myocardial Infarction": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.403'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Outpatient Consultation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Outpatient Encounters for Preventive Care": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1576'
valueset "PCI": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.67'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Individual Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Rhabdomyolysis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1047.102'
valueset "Stable and Unstable Angina": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1047.47'
valueset "Statin Allergen": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.42'
valueset "Statin Associated Muscle Symptoms": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1108.85'
valueset "Preventive Care Services Other": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.11.1150'

// HCPCS codes from Annual Wellness Visit value set, but with system http://www.nlm.nih.gov/research/umls/hcpcs
code "G0402": 'G0402' from "HCPCS" display 'G0402'
code "G0438": 'G0438' from "HCPCS" display 'G0438'
code "G0439": 'G0439' from "HCPCS" display 'G0439'
code "Ambulatory Procedures": '20460012' from "Cerner6000" display 'Ambulatory Procedures'
code "Evaluation and Management": '636067' from "Cerner6000" display 'Evaluation and Management'

code "Cardiovascular disease 10Y risk [Likelihood]": '99055-6' from "LOINC" display 'Cardiovascular disease 10Y risk [Likelihood]'
code "Cardiovascular disease 10Y risk [Likelihood] ACC-AHA Pooled Cohort by Goff 2013": '79423-0' from "LOINC" display 'Cardiovascular disease 10Y risk [Likelihood] ACC-AHA Pooled Cohort by Goff 2013'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2025-01-01T00:00:00.0, @2026-01-01T00:00:00.0)
context Patient

define "Initial Population 1":
  exists "ASVCD Diagnosis or Procedure before End of Measurement Period"
    and exists "Qualifying Encounter"

define "Initial Population 2":
  "Age at Start of Measurement Period" in Interval[20, 75]
    and (
      exists "LDL Result Greater Than or Equal To 190"
      or exists "Hypercholesterolemia Diagnosis"
    )
    and not exists ( "ASVCD Diagnosis or Procedure before End of Measurement Period" )
    and exists "Qualifying Encounter"

define "Initial Population 3":
  "Age at Start of Measurement Period" in Interval[40, 75]
    and exists "Diabetes Diagnosis"
    and not exists "ASVCD Diagnosis or Procedure before End of Measurement Period"
    and not exists "LDL Result Greater Than or Equal To 190"
    and not exists "Hypercholesterolemia Diagnosis"
    and exists "Qualifying Encounter"

define "Initial Population 4":
  "Age at Start of Measurement Period" in Interval[40, 75]
    and exists "Ten Year CVD Risk is High"
    and not exists "ASVCD Diagnosis or Procedure before End of Measurement Period"
    and not exists "Hypercholesterolemia Diagnosis"
    and not exists "LDL Result Greater Than or Equal To 190"
    and not exists "Diabetes Diagnosis"
    and exists "Qualifying Encounter"

define "Denominator 1":
  "Initial Population 1"

define "Denominator 2":
  "Initial Population 2"

define "Denominator 3":
  "Initial Population 3"

define "Denominator 4":
  "Initial Population 4"

define "Denominator Exclusions":
  exists "Exclusion Diagnosis"

define "Exclusion Diagnosis":
  ( [Condition: "Breastfeeding"]
      union [Condition: "Rhabdomyolysis"] ) ExclusionDiagnosis
      where ExclusionDiagnosis.prevalenceInterval ( ) overlaps day of "Measurement Period"
        and ExclusionDiagnosis.isActive ( )

define "Denominator Exceptions":
  exists "Allergy to Statin"
    or exists Hospice."Hospice Services"
    or exists PalliativeCare."Palliative Care in the Measurement Period"
    or exists "Hepatitis or Liver Disease Diagnosis"
    or exists "Statin Associated Muscle Symptoms Diagnosis"
    or exists "ESRD Diagnosis"
    or exists "Adverse Reaction to Statin"
    or exists "Medical Reason for Not Ordering Statin Therapy"

define "Numerator":
  exists "Statin Therapy Prescribed Anytime during day of Measurement Period"

define "ASVCD Diagnosis or Procedure before End of Measurement Period":
  ( ( [Condition: "Myocardial Infarction"]
      union [Condition: "Cerebrovascular Disease Stroke or TIA"]
      union [Condition: "Atherosclerosis and Peripheral Arterial Disease"]
      union [Condition: "Ischemic Heart Disease or Other Related Diagnoses"]
      union [Condition: "Stable and Unstable Angina"] ) ASCVDDiagnosis
      where ASCVDDiagnosis.prevalenceInterval ( ) starts on or before day of end of "Measurement Period"
        and ASCVDDiagnosis.isActive ( )
  )
    union ( ( [Procedure: "PCI"]
        union [Procedure: "CABG Surgeries"]
        union [Procedure: "Carotid Intervention"]
        union [Procedure: "CABG or PCI Procedure"] ) ASCVDProcedure
        where ASCVDProcedure.performed.toInterval ( ) starts on or before day of end of "Measurement Period"
          and ASCVDProcedure.status = 'completed'
    )

define "Adverse Reaction to Statin":
  [AdverseEvent: event in "Statin Allergen"] StatinReaction
      where StatinReaction.recordedDate during day of "Measurement Period"

define "Allergy to Statin":
  [AllergyIntolerance: "Statin Allergen"] StatinAllergy
      where StatinAllergy.onset.toInterval ( ) overlaps day of "Measurement Period"
        and StatinAllergy.clinicalStatus ~ QICoreCommon."allergy-active"

define "Diabetes Diagnosis":
  [Condition: "Diabetes"] Diabetes
      where Diabetes.prevalenceInterval ( ) overlaps day of "Measurement Period"
        and Diabetes.isActive ( )

define "ESRD Diagnosis":
  [Condition: "End Stage Renal Disease"] ESRD
      where ESRD.prevalenceInterval ( ) overlaps day of "Measurement Period"
        and ESRD.isActive ( )

define "Hepatitis or Liver Disease Diagnosis":
  ( [Condition: "Hepatitis A"]
      union [Condition: "Hepatitis B"]
      union [Condition: "Liver Disease"] ) HepatitisLiverDisease
      where HepatitisLiverDisease.prevalenceInterval ( ) overlaps day of "Measurement Period"
        and HepatitisLiverDisease.isActive ( )

define "Medical Reason for Not Ordering Statin Therapy":
  ( [MedicationNotRequested: "Low Intensity Statin Therapy"]
      union [MedicationNotRequested: "Moderate Intensity Statin Therapy"]
      union [MedicationNotRequested: "High Intensity Statin Therapy"] ) NoStatinTherapyOrdered
      with "Qualifying Encounter" QualifyingEncounter
        such that NoStatinTherapyOrdered.authoredOn during QualifyingEncounter.period
          and NoStatinTherapyOrdered.status = 'completed'
          and NoStatinTherapyOrdered.reasonCode in "Medical Reason"

define "Statin Associated Muscle Symptoms Diagnosis":
  [Condition: "Statin Associated Muscle Symptoms"] StatinMuscleSymptom
      where StatinMuscleSymptom.prevalenceInterval ( ) overlaps day of "Measurement Period"
        and StatinMuscleSymptom.isActive ( )

define "Hypercholesterolemia Diagnosis":
  ( [Condition: "Familial Hypercholesterolemia"] Hypercholesterolemia
      where Hypercholesterolemia.prevalenceInterval ( ) starts on or before day of end of "Measurement Period"
        and Hypercholesterolemia.isActive ( )
  )

define "LDL Result Greater Than or Equal To 190":
  [Observation: "LDL Cholesterol"] LDL190
    where LDL190.value as Quantity >= 190 'mg/dL'
      and LDL190.effective.toInterval ( ) starts on or before day of end of "Measurement Period"
      and LDL190.status in { 'final', 'amended', 'corrected', 'appended' }

define "Age at Start of Measurement Period":
  AgeInYearsAt(date from start of "Measurement Period")

define "Statin Therapy Prescribed Anytime during day of Measurement Period":
  ( [MedicationRequest: "Low Intensity Statin Therapy"]
    union [MedicationRequest: "Moderate Intensity Statin Therapy"]
    union [MedicationRequest: "High Intensity Statin Therapy"] ) StatinPrescribed
    where StatinPrescribed.status in { 'active', 'completed' }
      and StatinPrescribed.intent ~ 'order'
      and ( StatinPrescribed.authoredOn during day of "Measurement Period"
          or exists ( StatinPrescribed.dosageInstruction.timing T
              where T.repeat.bounds.toInterval ( ) overlaps day of "Measurement Period"
          )
      )

define "Qualifying Encounter":
  (( [Encounter] ).isEncounterPerformed()) ValidEncounter
    where ValidEncounter.period.toInterval() starts during day of "Measurement Period"
      and exists ("Qualifying Visit Charge" VC where VC.encounter.reference = 'Encounter/' + ValidEncounter.id)

define "Qualifying Visit Charge":
  (["ServiceRequest": "Annual Wellness Visit"]
    union ["ServiceRequest": "Office Visit"]
    union ["ServiceRequest": "Outpatient Consultation"]
    union ["ServiceRequest": "Outpatient Encounters for Preventive Care"]
    union ["ServiceRequest": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["ServiceRequest": "Preventive Care Services Individual Counseling"]
    union ["ServiceRequest": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["ServiceRequest": "Preventive Care Services Other"]
    union ["ServiceRequest": "G0402"]
    union ["ServiceRequest": "G0438"]
    union ["ServiceRequest": "G0439"] ) ValidCharge
      where ValidCharge.status = 'completed'
        and (exists (ValidCharge.category C
          where C ~ "Ambulatory Procedures" or C ~ "Evaluation and Management")
        )

define "Ten Year CVD Risk is High":
   ( [Observation: "Cardiovascular disease 10Y risk [Likelihood]"]
      union [Observation: "Cardiovascular disease 10Y risk [Likelihood] ACC-AHA Pooled Cohort by Goff 2013"] ) AtRiskCVD
      where AtRiskCVD.value as Quantity >= 20 '%'
        and AtRiskCVD.effective.toInterval ( ) during day of "Measurement Period"

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
  SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
  SDE."SDE Sex"

// Debug All Encounters in Period
define "Debug Encounter":
  ( ([Encounter]).isEncounterPerformed()) ValidEncounter
    where ValidEncounter.period.toInterval() starts during day of "Measurement Period"

// Debug All Encounters in Period and their organizations
define "Debug Encounter Organization":
  from "Debug Encounter" E
    let Org: singleton from ([Organization] O where E.serviceProvider.reference = 'Organization/' + O.id)
    return {id: E.id, period: E.period, type: E.type, serviceType: E.serviceType, organization: Org.name}

// Debug All Visit Charges
define "Debug Visit Charge":
  (["ServiceRequest"]) ValidCharge
      where ValidCharge.status = 'completed'
        and (exists (ValidCharge.category C
          where C ~ "Ambulatory Procedures" or C ~ "Evaluation and Management")
        )

// Debug All Encounters in Period and their charges
define "Debug Encounter Visit Charge":
  from "Debug Visit Charge" VC,
    "Debug Encounter" E
  where VC.encounter.reference = 'Encounter/' + E.id
  return {id: E.id, period: E.period, type: E.type, serviceType: E.serviceType, visitCharge: VC.code}
