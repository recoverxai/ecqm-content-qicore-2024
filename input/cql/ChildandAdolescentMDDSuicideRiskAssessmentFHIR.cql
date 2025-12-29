library ChildandAdolescentMDDSuicideRiskAssessmentFHIR version '0.1.000'

using QICore version '4.1.1'

include SupplementalDataElements version '3.4.000' called SDE
include QICoreCommon version '2.0.000' called QICoreCommon
include FHIRHelpers version '4.3.000' called FHIRHelpers
include CQMCommon version '2.0.000' called CQMCommon

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "ActCode": 'http://terminology.hl7.org/CodeSystem/v3-ActCode'
codesystem "ICD10CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "Cerner6000": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/6000'
codesystem "Cerner72": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/72'

valueset "Group Psychotherapy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1187'
valueset "Major Depressive Disorder Active": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1491'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Outpatient Consultation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Psych Visit Diagnostic Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit for Family Psychotherapy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1018'
valueset "Psych Visit Psychotherapy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1496'
valueset "Psychoanalysis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1141'
valueset "Telehealth Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1031'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Suicide risk assessment (procedure)": '225337009' from "SNOMEDCT" display 'Suicide risk assessment (procedure)'
code "AMB": 'AMB' from "ActCode" display 'Ambulatory'
code "C-SSRS-1": '2551882259' from "Cerner72" display 'C-SSRS-1'
code "C-SSRS-2": '2816973581' from "Cerner72" display 'C-SSRS-2'
code "C-SSRS-6": '2816973685' from "Cerner72" display 'C-SSRS-6'

code "Ambulatory Procedures": '20460012' from "Cerner6000" display 'Ambulatory Procedures'
code "Evaluation and Management": '636067' from "Cerner6000" display 'Evaluation and Management'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2025-01-01T00:00:00.0, @2026-01-01T00:00:00.0)
  
context Patient

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
  SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
  SDE."SDE Sex"

define "Initial Population":
  from "Qualifying Encounter And Age at Start of Measurement Period" EncounterAndAge
    where EncounterAndAge.Age >= 6 and EncounterAndAge.Age <= 16
  return EncounterAndAge.episode

define "Denominator":
  "Initial Population"

define "Numerator":
  "Encounter with Suicide Risk Assessment".episode

define "Encounter with Suicide Risk Assessment":
  from "Qualifying Encounter" MDDEncounter,
       ["Observation": "C-SSRS-1"] CSSRS1,
       ["Observation": "C-SSRS-2"] CSSRS2,
       ["Observation": "C-SSRS-6"] CSSRS6
    where CSSRS1.status = 'final'
      and CSSRS2.status = 'final'
      and CSSRS6.status = 'final'
      and QICoreCommon."ToInterval"(CSSRS1.effective) during MDDEncounter.period
      and QICoreCommon."ToInterval"(CSSRS2.effective) during MDDEncounter.period
      and QICoreCommon."ToInterval"(CSSRS6.effective) during MDDEncounter.period
  return {
    episode: MDDEncounter,
    "1_C-SSRS-1": CSSRS1,
    "2_C-SSRS-2": CSSRS2,
    "3_C-SSRS-6": CSSRS6
  }

define "Qualifying Encounter And Age at Start of Measurement Period":
  from "Qualifying Encounter" QualifyingEncounter,
    "Age at Start of Measurement Period" Age
  return {episode: QualifyingEncounter, "Qualifying Encounter": QualifyingEncounter, Age: Age}

define "Age at Start of Measurement Period":
  AgeInYearsAt(start of "Measurement Period")

define "Qualifying Encounter":
  ["Encounter"] ValidEncounter
    where ValidEncounter.period.toInterval ( ) during day of "Measurement Period"
      and ValidEncounter.status ~ 'finished'
      and exists ("Qualifying Visit Charge" VC where VC.encounter.reference = 'Encounter/' + ValidEncounter.id)
      and exists ("MDD Condition" MDD where MDD.encounter.reference = 'Encounter/' + ValidEncounter.id)

define "MDD Condition":
  [Condition: "Major Depressive Disorder Active"]

define "Qualifying Visit Charge":
  ([ServiceRequest: "Office Visit"]
    union [ServiceRequest: "Outpatient Consultation"]
    union [ServiceRequest: "Psych Visit Diagnostic Evaluation"]
    union [ServiceRequest: "Psych Visit for Family Psychotherapy"]
    union [ServiceRequest: "Psych Visit Psychotherapy"]
    union [ServiceRequest: "Psychoanalysis"]
    union [ServiceRequest: "Group Psychotherapy"]
    union [ServiceRequest: "Telehealth Services"] ) ValidCharge
      where ValidCharge.status = 'completed'
        and (exists (ValidCharge.category C
          where C ~ "Ambulatory Procedures" or C ~ "Evaluation and Management")
        )