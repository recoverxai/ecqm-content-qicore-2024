library PalliativeCare version '1.9.000'

using QICore version '4.1.1'

include FHIRHelpers version '4.3.000' called FHIRHelpers
include QICoreCommon version '2.0.000' called QICoreCommon
include Status version '1.6.000' called Status

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct'

valueset "Palliative Care Encounter": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1090'
valueset "Palliative Care Intervention": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1135'
valueset "Palliative Care Diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.1167'

code "Functional Assessment of Chronic Illness Therapy - Palliative Care Questionnaire (FACIT-Pal)": '71007-9' from "LOINC" display 'Functional Assessment of Chronic Illness Therapy - Palliative Care Questionnaire (FACIT-Pal)'
code "Palliative care service": '310073009' from "SNOMEDCT" display 'Palliative care service (qualifier value)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Has Palliative Care in the Measurement Period":
  exists ("Palliative Care in the Measurement Period")

define "Palliative Care in the Measurement Period":
  ((([Observation: "Functional Assessment of Chronic Illness Therapy - Palliative Care Questionnaire (FACIT-Pal)"]).isAssessmentPerformed()) PalliativeAssessment
      where PalliativeAssessment.effective.toInterval() overlaps day of "Measurement Period"
  )
    union ([Condition: "Palliative Care Diagnosis"] PalliativeDiagnosis
        where PalliativeDiagnosis.prevalenceInterval() overlaps day of "Measurement Period"
    )
    union ((([Encounter: "Palliative Care Encounter"]
      union [Encounter] ValidEncounter 
      where ValidEncounter.serviceType ~ "Palliative care service").isEncounterPerformed()) PalliativeEncounter
        where PalliativeEncounter.period.toInterval() overlaps day of "Measurement Period"
    )
    union ((([Procedure: "Palliative Care Intervention"]).isInterventionPerformed()) PalliativeIntervention
        where PalliativeIntervention.performed.toInterval() overlaps day of "Measurement Period"
    )
