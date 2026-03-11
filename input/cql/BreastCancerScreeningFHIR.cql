library BreastCancerScreeningFHIR version '0.0.001'

using QICore version '4.1.1'

include FHIRHelpers version '4.3.000' called FHIRHelpers
include SupplementalDataElements version '3.4.000' called SDE
include Hospice version '6.9.000' called Hospice
include PalliativeCare version '1.9.000' called PalliativeCare
include AdultOutpatientEncounters version '4.8.000' called AdultOutpatientEncounters
include AdvancedIllnessandFrailty version '1.8.000' called AdvancedIllnessandFrailty
include Status version '1.6.000' called Status
include QICoreCommon version '2.0.000' called QICoreCommon

codesystem "AdministrativeGender": 'http://terminology.hl7.org/CodeSystem/v3-AdministrativeGender'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "LOINC": 'http://loinc.org'
codesystem "Cerner6000": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/6000'

valueset "Bilateral Mastectomy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1005'
valueset "History of bilateral mastectomy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1068'
valueset "Mammography": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1018'
valueset "Status Post Left Mastectomy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1069'
valueset "Status Post Right Mastectomy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1070'
valueset "Unilateral Mastectomy Left": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1133'
valueset "Unilateral Mastectomy Right": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1134'
valueset "Unilateral Mastectomy, Unspecified Laterality": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1071'

code "Female": 'F' from "AdministrativeGender" display 'Female'
code "Left (qualifier value)": '7771000' from "SNOMEDCT" display 'Left (qualifier value)'
code "Right (qualifier value)": '24028007' from "SNOMEDCT" display 'Right (qualifier value)'

code "Ambulatory Procedures": '20460012' from "Cerner6000" display 'Ambulatory Procedures'
code "Evaluation and Management": '636067' from "Cerner6000" display 'Evaluation and Management'

code "Mammography Report": '36625-2' from "LOINC" display 'Mammography Report'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2025-01-01T00:00:00.000Z, @2025-12-31T23:59:59.999Z]

context Patient

define "Initial Population":
  "Age at End of Measurement Period" in Interval[52, 74]
    and "Patient Gender" = 'female'
    and exists "Qualifying Encounters"

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  exists Hospice."Hospice Services"
    or ( ( exists ( "Right Mastectomy Diagnosis" )
          or exists ( "Right Mastectomy Procedure" )
      )
        and ( exists ( "Left Mastectomy Diagnosis" )
            or exists ( "Left Mastectomy Procedure" )
        )
    )
    or exists "Bilateral Mastectomy Diagnosis"
    or exists "Bilateral Mastectomy Procedure"
    or (
      AdvancedIllnessandFrailty."Patient Age 66 or Older at End of Measurement Period" is not null
      and 
      (
        (
          exists (AdvancedIllnessandFrailty."Criteria Indicating Frailty")
          and (
            exists (AdvancedIllnessandFrailty."Advanced Illness in Year Before or During Measurement Period")
            or exists (AdvancedIllnessandFrailty."Dementia Medications in Year Before or During Measurement Period")
          )
        )
        or
        AdvancedIllnessandFrailty."Living Long Term in a Nursing Home" is not null
        or
        exists (AdvancedIllnessandFrailty."Discharged to a Nursing Home")
        or
        exists (AdvancedIllnessandFrailty."Encounter in a Nursing Home")
      )
    )
    or exists PalliativeCare."Palliative Care in the Measurement Period"

define "Numerator":
  exists ("Mammogram Observation since October 1 Two Years Prior to the Measurement Period")
    or exists ("Mammogram Service Request since October 1 Two Years Prior to the Measurement Period")
    or exists ("Mammography Report since October 1 Two Years Prior to the Measurement Period")

define "Age at End of Measurement Period":
  AgeInYearsAt(date from end of "Measurement Period")

define "Patient Gender":
  Patient.gender

define "Qualifying Encounters":
  AdultOutpatientEncounters."Qualifying Encounters"

define "Right Mastectomy Diagnosis":
  ( [Condition: "Status Post Right Mastectomy"] RightMastectomyProcedure
    union ( [Condition: "Unilateral Mastectomy, Unspecified Laterality"] UnilateralMastectomyDiagnosis
        where exists ( UnilateralMastectomyDiagnosis.bodySite S
            where S ~ "Right (qualifier value)"
        )
    ) ) RightMastectomy
    where RightMastectomy.prevalenceInterval ( ) starts on or before end of "Measurement Period"

define "Right Mastectomy Procedure":
  ( ( [Procedure: "Unilateral Mastectomy Right"] ).isProcedurePerformed ( ) ) UnilateralMastectomyRightPerformed
    where UnilateralMastectomyRightPerformed.performed.toInterval ( ) ends on or before end of "Measurement Period"

define "Left Mastectomy Diagnosis":
  ( [Condition: "Status Post Left Mastectomy"]
    union ( [Condition: "Unilateral Mastectomy, Unspecified Laterality"] UnilateralMastectomyDiagnosis
        where exists ( UnilateralMastectomyDiagnosis.bodySite S
            where S ~ "Left (qualifier value)"
        )
    ) ) LeftMastectomy
    where LeftMastectomy.prevalenceInterval ( ) starts on or before end of "Measurement Period"

define "Left Mastectomy Procedure":
  ( ( [Procedure: "Unilateral Mastectomy Left"] ).isProcedurePerformed ( ) ) UnilateralMastectomyLeftPerformed
    where UnilateralMastectomyLeftPerformed.performed.toInterval ( ) ends on or before end of "Measurement Period"

define "Bilateral Mastectomy Diagnosis":
  [Condition: "History of bilateral mastectomy"] BilateralMastectomyHistory
    where BilateralMastectomyHistory.prevalenceInterval ( ) starts on or before end of "Measurement Period"

define "Bilateral Mastectomy Procedure":
  ( ( [Procedure: "Bilateral Mastectomy"] ).isProcedurePerformed ( ) ) BilateralMastectomyPerformed
    where BilateralMastectomyPerformed.performed.toInterval ( ) ends on or before end of "Measurement Period"

define "Mammogram Observation since October 1 Two Years Prior to the Measurement Period":
  ( ( [Observation: "Mammography"] ).isDiagnosticStudyPerformed ( ) ) Mammogram
      where Mammogram.effective.toInterval ( ) ends during day of Interval["October 1 Two Years Prior to the Measurement Period", end of "Measurement Period"]

define "Mammogram Service Request since October 1 Two Years Prior to the Measurement Period":
  ( ( [ServiceRequest: "Mammography"] ).isDiagnosticStudyOrder ( ) ) MammogramRequest
      where MammogramRequest.occurrence.toInterval ( ) ends during day of Interval["October 1 Two Years Prior to the Measurement Period", end of "Measurement Period"]

define "Mammography Report since October 1 Two Years Prior to the Measurement Period":
  ( [DiagnosticReportNote: "Mammography Report"] ) Report
      where Report.effective.toInterval ( ) ends during day of Interval["October 1 Two Years Prior to the Measurement Period", end of "Measurement Period"]

define "Debug Mammogram Service Request":
  ( ( [ServiceRequest: "Mammography"] ) ) MammogramRequest

define "Debug2 Mammogram Service Request":
  ( ( [ServiceRequest: "Mammography"] ).isDiagnosticStudyOrder ( ) ) MammogramRequest

define "Debug3 Mammogram Service Request":
  ( ( [ServiceRequest: "Mammography"] ) ) MammogramRequest
  return MammogramRequest.occurrence.toInterval ( )

define "October 1 Two Years Prior to the Measurement Period":
  DateTime((year from start of "Measurement Period" - 2), 10, 1, 0, 0, 0, 0, 0)

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
