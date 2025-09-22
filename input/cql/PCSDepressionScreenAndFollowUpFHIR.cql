library PCSDepressionScreenAndFollowUpFHIR version '0.2.000'

using QICore version '4.1.1'

include QICoreCommon version '2.0.000' called QICoreCommon
include SupplementalDataElements version '3.4.000' called SDE
include FHIRHelpers version '4.3.000' called FHIRHelpers
include Status version '1.6.000' called Status

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "HCPCS": 'http://www.nlm.nih.gov/research/umls/hcpcs'
codesystem "ConditionVerificationStatusCodes": 'http://terminology.hl7.org/CodeSystem/condition-ver-status'
codesystem "Cerner6000": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/6000'
codesystem "CERNER-SR": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/200'
codesystem "Cerner72": 'https://fhir.cerner.com/24e03c9a-e2fd-45f4-8243-e38cc7e8418d/codeSet/72'

valueset "Adolescent Depression Medications": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1567'
valueset "Adult Depression Medications": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1566'
valueset "Bipolar Disorder": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.67.1.101.1.128'
valueset "Depression": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1248.169'
valueset "Encounter to Screen for Depression": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.600.1916'
valueset "Follow Up for Adolescent Depression": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1569'
valueset "Follow Up for Adult Depression": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1568'
valueset "Medical Reason": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1007'
valueset "Physical Therapy Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1022'
valueset "Referral for Adolescent Depression": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1570'
valueset "Referral for Adult Depression": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1571'
valueset "Telephone Visits": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1080'

code "Adolescent depression screening assessment": '73831-0' from "LOINC" display 'Adolescent depression screening assessment'
code "Adult depression screening assessment": '73832-8' from "LOINC" display 'Adult depression screening assessment'
code "Depression screening declined (situation)": '720834000' from "SNOMEDCT" display 'Depression screening declined (situation)'
code "Depression screening negative (finding)": '428171000124102' from "SNOMEDCT" display 'Depression screening negative (finding)'
code "Depression screening positive (finding)": '428181000124104' from "SNOMEDCT" display 'Depression screening positive (finding)'
code "Bipolar (qualifier value)": '260994008' from "SNOMEDCT" display 'Bipolar (qualifier value)'
code "PHQ-2": '55758-7' from "LOINC" display 'Patient Health Questionnaire 2 item (PHQ-2) total score [Reported]'
code "PHQ-9": '4316182' from "Cerner72" display 'Detailed Depression Screen Score'
code "Wound Care": '3661000175108' from "SNOMEDCT" display 'Wound care service (qualifier value)'
code "confirmed": 'confirmed' from ConditionVerificationStatusCodes display 'Confirmed'
code "Referral Management": '4659041987' from "CERNER-SR" display 'Referral Management'

// HCPCS codes from Encounter to Screen for Depression value set, but with system http://www.nlm.nih.gov/research/umls/hcpcs
code "G0101": 'G0101' from "HCPCS" display 'G0101'
code "G0270": 'G0270' from "HCPCS" display 'G0270'
code "G0271": 'G0271' from "HCPCS" display 'G0271'
code "G0402": 'G0402' from "HCPCS" display 'G0402'
code "G0438": 'G0438' from "HCPCS" display 'G0438'
code "G0439": 'G0439' from "HCPCS" display 'G0439'
code "G0444": 'G0444' from "HCPCS" display 'G0444'

code "Ambulatory Procedures": '20460012' from "Cerner6000" display 'Ambulatory Procedures'
code "Evaluation and Management": '636067' from "Cerner6000" display 'Evaluation and Management'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2025-01-01T00:00:00.0, @2026-01-01T00:00:00.0)
context Patient

define "Initial Population":
  "Age In Measurement Period" >= 12
    and exists ( "Qualifying Encounters" )

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  exists "History of Bipolar Diagnosis Before Qualifying Encounter"

define "Numerator":
  exists "Most Recent Depression Screening Negative"
  or
  (
    exists "Most Recent Depression Screening Positive"
    and
    (
      (
        "Patient Age 12 to 16 Years at Start of Measurement Period" is not null
        and
        exists "Most Recent Adolescent Depression Screening Positive and Follow Up Provided"
      )
      or
      ( 
        "Patient Age 17 Years at Start of Measurement Period" is not null
        and 
        (
          exists "Most Recent Adolescent Depression Screening Positive and Follow Up Provided"
          or 
          exists "Most Recent Adult Depression Screening Positive and Follow Up Provided"
        )
      )
      or
      (
        "Patient Age 18 Years or Older at Start of Measurement Period" is not null
        and
        exists "Most Recent Adult Depression Screening Positive and Follow Up Provided"
      )
    )
  )

define "Denominator Exceptions":
  exists "Medical or Patient Reason for Not Screening for Depression"
      and not exists "Initial Depression Screening"

define "History of Bipolar Diagnosis Before Qualifying Encounter":
  ([Condition: "Bipolar Disorder"]
    union [Condition: "Bipolar (qualifier value)"]) BipolarDiagnosis
    with "Qualifying Encounters" QualifyingEncounter
      such that BipolarDiagnosis.verificationStatus ~ "confirmed"
        and (BipolarDiagnosis.onset before (start of QualifyingEncounter.period)
        or (BipolarDiagnosis.onset is null and BipolarDiagnosis.recordedDate before or on day of QualifyingEncounter.period))

define "Medical or Patient Reason for Not Screening for Depression":
  [ObservationNotDone: code ~ "PHQ-2"] NoScreen
    with "Qualifying Encounters" QualifyingEncounter
      such that NoScreen.issued during QualifyingEncounter.period
    where ( NoScreen.notDoneReason ~ "Depression screening declined (situation)"
        or NoScreen.notDoneReason in "Medical Reason"
    )
      and NoScreen.status = 'cancelled'

define "Follow Up Intervention for Positive Adolescent Depression Screening":
  ( ( [MedicationRequest: "Adolescent Depression Medications"] AdolescentMed
        where AdolescentMed.status in { 'active', 'completed' }
          and AdolescentMed.intent = 'order'
    )
      union ( [ServiceRequest: "Referral for Adolescent Depression"] AdolescentReferral
          where AdolescentReferral.status in { 'active', 'completed' }
      )
      union ([ServiceRequest: "Referral Management"] ReferralManagement
        where 
          ReferralManagement.reasonCode in "Depression"
          and ReferralManagement.status in { 'active', 'completed' }
      )
      union ( [Procedure: "Follow Up for Adolescent Depression"] AdolescentFollowUp
          where AdolescentFollowUp.status = 'completed'
      )
  )

define "Follow Up Intervention for Positive Adult Depression Screening":
  ( ( [MedicationRequest: "Adult Depression Medications"] AdultMed
        where AdultMed.status in { 'active', 'completed' }
          and AdultMed.intent = 'order'
    )
      union ( [ServiceRequest: "Referral for Adult Depression"] AdultReferral
          where AdultReferral.status in { 'active', 'completed' }
      )
      union ([ServiceRequest: "Referral Management"] ReferralManagement
        where 
          ReferralManagement.reasonCode in "Depression"
          and ReferralManagement.status in { 'active', 'completed' }
      )
      union ( [Procedure: "Follow Up for Adult Depression"] AdultFollowUp
          where AdultFollowUp.status = 'completed'
      )
  )

  define "Debug Adult Depression Medications":
    [MedicationRequest: "Adult Depression Medications"] AdultMed
        where AdultMed.status in { 'active', 'completed' }
          and AdultMed.intent = 'order'

  define "Debug Referral for Adult Depression":
    ([ServiceRequest: "Referral for Adult Depression"] AdultReferral
          where AdultReferral.status in { 'active', 'completed' })
    union ([ServiceRequest: "Referral Management"] ReferralManagement
        where ReferralManagement.reasonCode in "Depression"
          and ReferralManagement.status in { 'active', 'completed' }
      )

  define "Debug Follow Up for Adult Depression":
    [Procedure: "Follow Up for Adult Depression"] AdultFollowUp
          where AdultFollowUp.status = 'completed'


define "Most Recent Initial Depression Screening Negative":
  "Most Recent Initial Depression Screening" DepressionScreen
      where DepressionScreen.value as Quantity < 3 '{score}'

define "Most Recent Initial Depression Screening Positive":
  "Most Recent Initial Depression Screening" DepressionScreen
      where DepressionScreen.value as Quantity >= 3 '{score}'

define "Most Recent Detailed Depression Screening Negative":
  "Most Recent Detailed Depression Screening" DepressionScreen
      where DepressionScreen.value as Quantity < 5

define "Most Recent Detailed Depression Screening Positive":
  "Most Recent Detailed Depression Screening" DepressionScreen
      where DepressionScreen.value as Quantity >= 5

define "Most Recent Depression Screening Negative":
  "Most Recent Initial Depression Screening" Initial
  let Detailed: "Most Recent Detailed Depression Screening",
    InitialNegative: "Most Recent Initial Depression Screening Negative",
    InitialPositive: "Most Recent Initial Depression Screening Positive",
    DetailedNegative: "Most Recent Detailed Depression Screening Negative"
  where
    InitialNegative is not null
    or (
      InitialPositive is not null
      and DetailedNegative is not null
    )
  return
    (List{Initial} 
    union 
    (if Detailed is not null then List{ Detailed } else List{}))

define "Most Recent Depression Screening Positive":
  "Most Recent Initial Depression Screening" Initial
  let Detailed: "Most Recent Detailed Depression Screening",
    InitialPositive: "Most Recent Initial Depression Screening Positive",
    DetailedNegative: "Most Recent Detailed Depression Screening Negative"
  where
    InitialPositive is not null
    and DetailedNegative is null
  return
    (List{Initial} 
    union 
    (if Detailed is not null then List{ Detailed } else List{}))

define "Most Recent Initial Depression Screening":
  Last("Initial Depression Screening")

define "Initial Depression Screening":
  [Observation: "PHQ-2"] InitialDepressionScreening
      with "Qualifying Encounters" QualifyingEncounter
        such that InitialDepressionScreening.effective.toInterval() 14 days or less on or before day of start of QualifyingEncounter.period
          and InitialDepressionScreening.value is not null
          and InitialDepressionScreening.status = 'final'
      sort by start of effective.toInterval()

define "Debug All Initial Depression Screening":
  [Observation: "PHQ-2"] InitialDepressionScreening
      where InitialDepressionScreening.value is not null and InitialDepressionScreening.status = 'final'
      sort by start of effective.toInterval()

define "Most Recent Detailed Depression Screening":
  Last([Observation: "PHQ-9"] DetailedDepressionScreening
      with "Most Recent Initial Depression Screening" InitialDepressionScreening
        such that DetailedDepressionScreening.encounter.reference = InitialDepressionScreening.encounter.reference
          and DetailedDepressionScreening.value is not null
          and DetailedDepressionScreening.status = 'final'
      sort by start of effective.toInterval())

define "Most Recent Adolescent Depression Screening Positive and Follow Up Provided":
  from
    "Most Recent Depression Screening Positive" LastDepressionScreen,
    "Follow Up Intervention for Positive Adolescent Depression Screening" FollowUpPositiveAdolescentScreen,
    "Qualifying Encounters" QualifyingEncounter
    where 
      "Most Recent Detailed Depression Screening Negative" is null
      and LastDepressionScreen.effective.toInterval ( ) starts 14 days or less on or before day of start of QualifyingEncounter.period
      and ( Coalesce(start of FollowUpPositiveAdolescentScreen.performed.toInterval(), FollowUpPositiveAdolescentScreen.authoredOn) during QualifyingEncounter.period
          or FollowUpPositiveAdolescentScreen.authoredOn 2 days or less on or after day of start of QualifyingEncounter.period
      )
      and ( Coalesce(start of FollowUpPositiveAdolescentScreen.performed.toInterval(), FollowUpPositiveAdolescentScreen.authoredOn) during day of "Measurement Period" )
  return 
    {DepressionScreen: LastDepressionScreen, Followup: FollowUpPositiveAdolescentScreen}

define "Most Recent Adult Depression Screening Positive and Follow Up Provided":
  from
    "Most Recent Depression Screening Positive" LastDepressionScreen,
    "Follow Up Intervention for Positive Adult Depression Screening" FollowUpPositiveAdultScreen,
    "Qualifying Encounters" QualifyingEncounter
    where 
      "Most Recent Detailed Depression Screening Negative" is null
      and LastDepressionScreen.effective.toInterval ( ) starts 14 days or less on or before day of start of QualifyingEncounter.period
      and ( Coalesce(start of FollowUpPositiveAdultScreen.performed.toInterval(), FollowUpPositiveAdultScreen.authoredOn) during QualifyingEncounter.period
          or FollowUpPositiveAdultScreen.authoredOn 2 days or less on or after day of start of QualifyingEncounter.period
      )
      and ( Coalesce(start of FollowUpPositiveAdultScreen.performed.toInterval(), FollowUpPositiveAdultScreen.authoredOn) during day of "Measurement Period" )
  return 
    {DepressionScreen: LastDepressionScreen, Followup: FollowUpPositiveAdultScreen}
    
define "Debug Adult Depression Screening Follow Up Provided":
  from
    "Follow Up Intervention for Positive Adult Depression Screening" FollowUpPositiveAdultScreen
    where ( Coalesce(start of FollowUpPositiveAdultScreen.performed.toInterval(), FollowUpPositiveAdultScreen.authoredOn) during day of "Measurement Period" )

define "Age In Measurement Period":
  AgeInYearsAt(date from
    start of "Measurement Period"
  )

define "Patient Age 12 to 16 Years at Start of Measurement Period":
  from "Age In Measurement Period" age 
    where age in Interval[12, 16]
  return age

define "Patient Age 17 Years at Start of Measurement Period":
  from "Age In Measurement Period" age 
      where age = 17
    return age

define "Patient Age 18 Years or Older at Start of Measurement Period":
  from "Age In Measurement Period" age 
      where age >= 18
    return age

define "Qualifying Encounters":
  (( [Encounter] ).isEncounterPerformed()) ValidEncounter
    where ValidEncounter.period.toInterval() starts during day of "Measurement Period"
      and exists ("Qualifying Visit Charge" VC where VC.encounter.reference = 'Encounter/' + ValidEncounter.id)

define "Qualifying Visit Charge":
  (["ServiceRequest": "Encounter to Screen for Depression"]
    union ["ServiceRequest": "Physical Therapy Evaluation"]
    union ["ServiceRequest": "Telephone Visits"]
    union [ServiceRequest: "G0101"]
    union [ServiceRequest: "G0270"]
    union [ServiceRequest: "G0271"]
    union [ServiceRequest: "G0402"]
    union [ServiceRequest: "G0438"]
    union [ServiceRequest: "G0439"]
    union [ServiceRequest: "G0444"] ) ValidCharge
      where ValidCharge.status = 'completed'
        and (exists (ValidCharge.category C
          where C ~ "Ambulatory Procedures" or C ~ "Evaluation and Management")
        )

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
