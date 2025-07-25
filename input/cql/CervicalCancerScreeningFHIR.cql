library CervicalCancerScreeningFHIR version '0.0.001'

using QICore version '4.1.1'

include FHIRHelpers version '4.3.000' called FHIRHelpers
include SupplementalDataElements version '3.4.000' called SDE
include QICoreCommon version '2.0.000' called QICoreCommon
include Hospice version '6.9.000' called Hospice
include PalliativeCare version '1.9.000' called PalliativeCare
include Status version '1.6.000' called Status

codesystem "CERNER-72": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/72'
codesystem "HCPCS": 'http://www.nlm.nih.gov/research/umls/hcpcs'
codesystem "Cerner6000": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/6000'

valueset "Congenital or Acquired Absence of Cervix": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.111.12.1016'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "HPV Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1059'
valueset "Hysterectomy with No Residual Cervix": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1014'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Online Assessments": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Pap Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1017'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Telephone Visits": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1080'
valueset "Hysterectomy": 'ValueSet/evdm-hysterectomy'

code "Last Pap Result, Pt Stated": '3819002389' from "CERNER-72" display 'Last Pap Result, Pt Stated'
code "Last Pap Result Comment": '3819002413' from "CERNER-72" display 'Last Pap Result Comment'
code "Pap Smear Abnormal Result Comment": '2556342625' from "CERNER-72" display 'Pap Smear Abnormal Result Comment'
code "Date of Last Pap Smear": '704864' from "CERNER-72" display 'Date of Last Pap Smear'
code "Pap Smear Date Performed": '2556342649' from "CERNER-72" display 'Pap Smear Date Performed'
code "Pap Smear, Transcribed": '2556342601' from "CERNER-72" display 'Pap Smear, Transcribed'
code "Date of Last HPV Exam, Pt Stated": '14256783065' from "CERNER-72" display 'Date of Last HPV Exam, Pt Stated'
code "Last HPV Result Comments": '14256783147' from "CERNER-72" display 'Last HPV Result Comments'
code "Last HPV Result, Pt Stated": '14256783109' from "CERNER-72" display 'Last HPV Result, Pt Stated'

// HCPCS codes from Online Assessments value set, but with system http://www.nlm.nih.gov/research/umls/hcpcs
code "G0071": 'G0071' from "HCPCS" display 'G0071'
code "G2010": 'G2010' from "HCPCS" display 'G2010'
code "G2250": 'G2250' from "HCPCS" display 'G2250'
code "G2251": 'G2251' from "HCPCS" display 'G2251'
code "G2252": 'G2252' from "HCPCS" display 'G2252'

code "Ambulatory Procedures": '20460012' from "Cerner6000" display 'Ambulatory Procedures'
code "Evaluation and Management": '636067' from "Cerner6000" display 'Evaluation and Management'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2025-01-01T00:00:00.0, @2026-01-01T00:00:00.0)
context Patient

define "Age In Measurement Period":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  )

define "Patient Gender":
  Patient.gender

define "Initial Population":
  "Age In Measurement Period" in Interval[24, 64]
    and "Patient Gender" = 'female'
    and exists "Qualifying Encounters"

define "Qualifying Encounters":
  ( ( ["Encounter"]).isEncounterPerformed ( ) ) ValidEncounters
    where ValidEncounters.period.toInterval ( ) starts during day of "Measurement Period"
      and exists ("Qualifying Visit Charge" VC where VC.encounter.reference = 'Encounter/' + ValidEncounters.id)

define "Qualifying Visit Charge":
  ([ServiceRequest: "Office Visit"]
    union [ServiceRequest: "Preventive Care Services Established Office Visit, 18 and Up"]
      union [ServiceRequest: "Preventive Care Services Initial Office Visit, 18 and Up"]
      union [ServiceRequest: "Home Healthcare Services"]
      union [ServiceRequest: "Telephone Visits"]
      union [ServiceRequest: "Online Assessments"]
      union [ServiceRequest: "G0071"]
      union [ServiceRequest: "G2010"]
      union [ServiceRequest: "G2250"]
      union [ServiceRequest: "G2251"]
      union [ServiceRequest: "G2252"] ) ValidCharge
      where ValidCharge.status = 'completed'
        and (exists (ValidCharge.category C
          where C ~ "Ambulatory Procedures" or C ~ "Evaluation and Management")
        )

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  exists Hospice."Hospice Services"
    or exists "Absence of Cervix"
    or exists PalliativeCare."Palliative Care in the Measurement Period"

define "Potential Denominator Exclusion":
  (exists "No Cervix No Date"
  or exists "Other Hyst Review for Absence of Cervix")
  and not "Denominator Exclusions"


define "Numerator":
  exists "Cervical Cytology Within 3 Years"
    or exists "HPV Test Within 5 Years for Women Age 30 and Older"

define "Potential Numerator":
  (exists "Pap Test Ordered"
  or exists "HPV Test Ordered"
  or exists "Non compliant Cervical Cytology Within 3 Years"
  or exists "Non compliant HPV Test Within 5 Years for Women Age 30 and Older")
  and not "Numerator"

define "Absence of Cervix":
  ( ( ( ["Procedure": "Hysterectomy with No Residual Cervix"] ).isProcedurePerformed ( ) ) NoCervixProcedure
      where NoCervixProcedure.performed.toInterval ( ) ends on or before end of "Measurement Period"
  )
    union ( ["Condition": "Congenital or Acquired Absence of Cervix"] NoCervixDiagnosis
        where NoCervixDiagnosis.prevalenceInterval ( ) starts on or before end of "Measurement Period"
    )

define "No Cervix No Date":
  (((["Procedure": "Hysterectomy with No Residual Cervix"] ).isProcedurePerformed ( ) ) NoCervixProcedure
    where NoCervixProcedure.performed is null)
  union ( ["Condition": "Congenital or Acquired Absence of Cervix"] NoCervixDiagnosis
    where NoCervixDiagnosis.prevalenceInterval ( ) is null)

define "Other Hyst Review for Absence of Cervix":
  ((["Procedure": "Hysterectomy"] ).isProcedurePerformed ( ) ) HysterectomyProcedure

define "Pap Test Ordered":
  ( [ServiceRequest: "Pap Test"]) PapOrder
    where QICoreCommon."ToInterval" ( PapOrder.authoredOn ) during day  of Interval[start of "Measurement Period" - 2 years, end of "Measurement Period"]

define "HPV Test Ordered":
  ( [ServiceRequest: "HPV Test"]) HPVOrder
    where AgeInYearsAt(date from HPVOrder.authoredOn.latest()) >= 30
      and HPVOrder.authoredOn.latest ( ) during day of Interval[start of "Measurement Period" - 4 years, end of "Measurement Period"]

define "Non compliant Cervical Cytology Within 3 Years":
   ( ( ["Observation": "Last Pap Result, Pt Stated"]
      union ["Observation": "Last Pap Result Comment"]
      union ["Observation": "Pap Smear Abnormal Result Comment"]
      union ["Observation": "Date of Last Pap Smear"]
      union ["Observation": "Pap Smear Date Performed"]
      union ["Observation": "Pap Smear, Transcribed"] ) ) CervicalCytology
    where CervicalCytology.effective.latest ( ) during day of Interval[start of "Measurement Period" - 2 years, end of "Measurement Period"]
      and CervicalCytology.value is not null

define "Non compliant HPV Test Within 5 Years for Women Age 30 and Older":
  (( ["Observation": "Date of Last HPV Exam, Pt Stated"] 
      union ["Observation": "Last HPV Result, Pt Stated"]
      union ["Observation": "Last HPV Result Comments"]
      union ["Observation": "Last HPV Result, Pt Stated"]) ) HPVTest
    where AgeInYearsAt(date from HPVTest.effective.latest()) >= 30
      and HPVTest.effective.latest ( ) during day of Interval[start of "Measurement Period" - 4 years, end of "Measurement Period"]
      and HPVTest.value is not null

define "Cervical Cytology Within 3 Years":
  ( ( ["Observation": "Pap Test"] ).isLaboratoryTestPerformed ( ) ) CervicalCytology
    where CervicalCytology.effective.latest ( ) during day of Interval[start of "Measurement Period" - 2 years, end of "Measurement Period"]
      and CervicalCytology.value is not null

define "HPV Test Within 5 Years for Women Age 30 and Older":
  ( ( ["Observation": "HPV Test"] ).isLaboratoryTestPerformed ( ) ) HPVTest
    where AgeInYearsAt(date from HPVTest.effective.latest()) >= 30
      and HPVTest.effective.latest ( ) during day of Interval[start of "Measurement Period" - 4 years, end of "Measurement Period"]
      and HPVTest.value is not null

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
