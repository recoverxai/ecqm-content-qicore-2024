library ChlamydiaScreeninginWomenFHIR version '0.1.000'

using QICore version '4.1.1'

include FHIRHelpers version '4.4.000' called FHIRHelpers
include QICoreCommon version '2.1.000' called QICoreCommon
include SupplementalDataElements version '3.5.000' called SDE
include Hospice version '6.12.000' called Hospice
include CumulativeMedicationDuration version '4.1.000' called CMD
include Status version '1.8.000' called Status

codesystem "AdministrativeGender": 'http://terminology.hl7.org/CodeSystem/v3-AdministrativeGender'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "CERNER": 'https://fhir.cerner.com/7614e3af-e4eb-4094-af40-f129322755cb/codeSet/71'

valueset "Chlamydia Screening": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1052'
valueset "Complications of Pregnancy, Childbirth and the Puerperium": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.111.12.1012'
valueset "Contraceptive Medications": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1080'
valueset "Diagnoses Used to Indicate Sexual Activity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.111.12.1018'
valueset "Diagnostic Studies During Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.111.12.1008'
valueset "HIV": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.120.12.1003'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Isotretinoin": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1143'
valueset "Lab Tests During Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.111.12.1007'
valueset "Lab Tests for Sexually Transmitted Infections": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1051'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Virtual Encounter": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Pap Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1017'
valueset "Pregnancy Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.111.12.1011'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Procedures Used to Indicate Sexual Activity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.111.12.1017'
valueset "Telephone Visits": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1080'
valueset "XRay Study": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1034'

code "Female": 'F' from "AdministrativeGender" display 'Female'
code "Have you ever had vaginal intercourse [PhenX]": '64728-9' from "LOINC" display 'Have you ever had vaginal intercourse [PhenX]'
code "Yes (qualifier value)": '373066001' from "SNOMEDCT" display 'Yes (qualifier value)'
code "Clinic": '22282402' from "CERNER" display 'Clinic'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2025-01-01T00:00:00.000Z, @2025-12-31T23:59:59.999Z]

context Patient

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
  SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
  SDE."SDE Sex"

define "Age In Measurement Period":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  )

define "Patient Gender":
  Patient.gender

define "Initial Population":
  "Age In Measurement Period" in Interval[16, 24]
    and "Patient Gender" = 'female'
    and exists ( "Qualifying Encounters" )
    and ( exists ( "Assessments Identifying Sexual Activity" )
        or exists ( "Diagnoses Identifying Sexual Activity" )
        or exists ( "Active Contraceptive Medications" )
        or exists ( "Ordered Contraceptive Medications" )
        or exists ( "Laboratory Tests Identifying Sexual Activity" )
        or exists ( "Diagnostic Studies Identifying Sexual Activity" )
        or exists ( "Procedures Identifying Sexual Activity" )
    )

define "Qualifying Encounters":
  ( ( [Encounter: "Office Visit"]
      union [Encounter: "Preventive Care Services Established Office Visit, 18 and Up"]
      union [Encounter: "Preventive Care Services Initial Office Visit, 18 and Up"]
      union [Encounter: "Preventive Care Services, Initial Office Visit, 0 to 17"]
      union [Encounter: "Preventive Care, Established Office Visit, 0 to 17"]
      union [Encounter: "Home Healthcare Services"]
      union [Encounter: "Telephone Visits"]
      union [Encounter: "Virtual Encounter"]
      union [Encounter: "Clinic"]
  ).isEncounterPerformed ( ) ) ValidEncounters
    where ValidEncounters.period.toInterval ( ) during day of "Measurement Period"

define "Diagnoses Identifying Sexual Activity":
  ( [Condition: "Diagnoses Used to Indicate Sexual Activity"]
      union [Condition: "HIV"]
      union [Condition: "Complications of Pregnancy, Childbirth and the Puerperium"] ) SexualActivityDiagnosis
      where SexualActivityDiagnosis.prevalenceInterval ( ) overlaps "Measurement Period"

define "Active Contraceptive Medications":
  ((["MedicationRequest": "Contraceptive Medications"]).isMedicationActive ( ) ) ActiveContraceptives
      where CMD."MedicationRequestPeriod" ( ActiveContraceptives ) overlaps "Measurement Period"

define "Ordered Contraceptive Medications":
  ( ( [MedicationRequest: "Contraceptive Medications"] ).isMedicationOrder ( ) ) OrderedContraceptives
    where OrderedContraceptives.authoredOn.toInterval ( ) during day of "Measurement Period"

define "Laboratory Tests Identifying Sexual Activity But Not Pregnancy":
  (( [ServiceRequest: "Pap Test"]
      union [ServiceRequest: "Lab Tests During Pregnancy"]
      union [ServiceRequest: "Lab Tests for Sexually Transmitted Infections"]
  ).isLaboratoryTestOrder ( )) LabOrders
    where LabOrders.authoredOn.toInterval ( ) during day of "Measurement Period"
            //   and LabOrders.doNotPerform is not true
            //   https://oncprojectracking.healthit.gov/support/browse/CQLIT-447



define "Laboratory Tests Identifying Sexual Activity":
  ( ( ( [ServiceRequest: "Pregnancy Test"] ).isLaboratoryTestOrder ( ) ) PregnancyTest
      where PregnancyTest.authoredOn.toInterval ( ) during day of "Measurement Period"
    //   and PregnancyTest.doNotPerform is not true
    //   https://oncprojectracking.healthit.gov/support/browse/CQLIT-447
  
  
  )
  union "Laboratory Tests Identifying Sexual Activity But Not Pregnancy"

define "Diagnostic Studies Identifying Sexual Activity":
  ( ( [ServiceRequest: "Diagnostic Studies During Pregnancy"] ).isDiagnosticStudyOrder ( ) ) SexualActivityDiagnostics
    where SexualActivityDiagnostics.authoredOn.toInterval ( ) during day of "Measurement Period"
            //   and SexualActivityDiagnostics.doNotPerform is not true
            //   https://oncprojectracking.healthit.gov/support/browse/CQLIT-447   



define "Procedures Identifying Sexual Activity":
  ( ( [Procedure: "Procedures Used to Indicate Sexual Activity"] ).isProcedurePerformed ( ) ) ProceduresForSexualActivity
    where ProceduresForSexualActivity.performed.toInterval ( ) during day of "Measurement Period"

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or ( exists ( "Pregnancy Test Exclusion" )
        and not exists ( "Assessments Identifying Sexual Activity" )
        and not exists ( "Diagnoses Identifying Sexual Activity" )
        and not exists ( "Active Contraceptive Medications" )
        and not exists ( "Ordered Contraceptive Medications" )
        and not exists ( "Laboratory Tests Identifying Sexual Activity But Not Pregnancy" )
        and not exists ( "Diagnostic Studies Identifying Sexual Activity" )
        and not exists ( "Procedures Identifying Sexual Activity" )
    )

define "Pregnancy Test Exclusion":
  ( ( ( ( [ServiceRequest: "Pregnancy Test"] ).isLaboratoryTestOrder ( ) ) PregnancyTest
        with ( ( [ServiceRequest: "XRay Study"] ).isDiagnosticStudyOrder ( ) ) XrayOrder
          such that XrayOrder.authoredOn.toInterval ( ) occurs 6 days or less on or after day of PregnancyTest.authoredOn.toInterval ( )
        where PregnancyTest.authoredOn.toInterval ( ) during "Measurement Period"
        //   and PregnancyTest.doNotPerform is not true
        //   https://oncprojectracking.healthit.gov/support/browse/CQLIT-447
    
    
    )
      union ( ( ( [ServiceRequest: "Pregnancy Test"] ).isLaboratoryTestOrder ( ) ) PregnancyTestOrder
          with ( ( [MedicationRequest: "Isotretinoin"] ).isMedicationOrder ( ) ) AccutaneOrder
            such that AccutaneOrder.authoredOn.toInterval ( ) occurs 6 days or less on or after day of PregnancyTestOrder.authoredOn.toInterval ( )
          where PregnancyTestOrder.authoredOn.toInterval ( ) during "Measurement Period"
            //   and PregnancyTestOrder.doNotPerform is not true
            //   https://oncprojectracking.healthit.gov/support/browse/CQLIT-447 
      
      
      )
  )

define "Chlamydia Screening Performed":
  ( ( ( [Observation: "Chlamydia Screening"] ).isLaboratoryTestPerformed ( ) ) ChlamydiaTest
      where ChlamydiaTest.effective.latest ( ) during day of "Measurement Period"
        and ChlamydiaTest.value is not null
  )

define "Numerator":
  exists "Chlamydia Screening Performed"

define "Stratification 1":
  "Age In Measurement Period" in Interval[16, 20]

define "Stratification 2":
  "Age In Measurement Period" in Interval[21, 24]

define "Assessments Identifying Sexual Activity":
  ( ( ( [Observation: "Have you ever had vaginal intercourse [PhenX]"] ).isAssessmentPerformed ( ) ) SexualActivityAssessment
      where SexualActivityAssessment.value ~ "Yes (qualifier value)"
        and SexualActivityAssessment.effective.toInterval ( ) on or before end of "Measurement Period"
  )