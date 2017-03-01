@AdditionalPayments
Feature: 16 to 18 learner incentives, framework uplifts, level 2 english or maths payments
  
   Scenario:AC1- Payment for a 16-18 DAS learner, levy available, incentives earned
    
    Given levy balance > agreed price for all months
    And the following commitments exist:
          | ULN       | start date | end date   | agreed price | status |
          | learner a | 01/08/2017 | 01/08/2018 | 15000        | active |

    When an ILR file is submitted with the following data:
          | ULN       | learner type             | agreed price | start date | planned end date | actual end date | completion status |
          | learner a | 16-18 programme only DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        |
      
    Then the provider earnings and payments break down as follows:
          | Type                                | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
          | Provider Earned Total               | 1000  | 1000  | 1000  | 2000  | 1000  | ... | 1000  | 0     |
          | Provider Paid by SFA                | 0     | 1000  | 1000  | 1000  | 2000  | ... | 1000  | 1000  |
          | Levy account debited                | 0     | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     |
          | SFA Levy employer budget            | 1000  | 1000  | 1000  | 1000  | 1000  | ... | 0     | 0     |
          | SFA Levy co-funding budget          | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     |
          | SFA Levy additional payments budget | 0     | 0     | 0     | 1000  | 0     | ... | 1000  | 0     |

    And the transaction types for the payments are:
          | Payment type             | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
          | On-program               | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     |
          | Completion               | 0     | 0     | 0     | 0     | ... | 0     | 0     |
          | Balancing                | 0     | 0     | 0     | 0     | ... | 0     | 0     |
          | Employer 16-18 incentive | 0     | 0     | 0     | 500   | ... | 0     | 500   |
          | Provider 16-18 incentive | 0     | 0     | 0     | 500   | ... | 0     | 500   |


Scenario:AC2- Payment for a 16-18 DAS learner, levy available, incentives not paid as data lock fails
    
    Given levy balance > agreed price for all months
    And the following commitments exist:
        | commitment number | ULN       | start date | end date   | agreed price | status |
        | 1                 | learner a | 01/09/2017 | 01/09/2018 | 15000        | active |
    
     When an ILR file is submitted with the following data:
        | ULN       | learner type             | agreed price | start date | planned end date | actual end date | completion status |
        | learner a | 16-18 programme only DAS | 15000        | 28/08/2017 | 29/08/2018       |                 | continuing        |
      
    Then the data lock status will be as follows:
        | type                | 08/17 onwards |   
        | matching commitment |               |   
      
    And the provider earnings and payments break down as follows:
        | Type                                | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
        | Provider Earned Total               | 1000  | 1000  | 1000  | 2000  | 1000  | ... | 1000  | 0     |
        | Provider Paid by SFA                | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Levy account debited                | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | SFA Levy employer budget            | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | SFA Levy co-funding budget          | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | SFA Levy additional payments budget | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     |
      

Scenario:AC3-Learner finishes on time, earns on-programme and completion payments. Assumes 12 month apprenticeship and learner completes after 10 months.

	When an ILR file is submitted with the following data:
		| ULN    | learner type                 | agreed price | start date | planned end date | actual end date | completion status | Framework Code | Programme Type | Pathway Code |
		| 123456 | 16-18 programme only non-DAS | 9000         | 06/08/2017 | 09/08/2018       | 10/08/2018      | Completed         | 403            | 2              | 1            |

	Then the provider earnings and payments break down as follows:
		| Type                                    | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 06/18 | 07/18 | 08/18 | 09/18 |
		| Provider Earned Total                   | 720   | 720   | 720   | 1720  | 720   | ... | 720   | 720   | 3160  | 0     |
		| Provider Earned from SFA                | 660   | 660   | 660   | 1660  | 660   | ... | 660   | 660   | 2980  | 0     |
		| Provider Earned from Employer           | 60    | 60    | 60    | 60    | 60    | ... | 60    | 60    | 180   | 0     |
		| Provider Paid by SFA                    | 0     | 660   | 660   | 660   | 1660  | ... | 660   | 660   | 660   | 2980  |
		| Payment due from Employer               | 0     | 60    | 60    | 60    | 60    | ... | 60    | 60    | 60    | 180   |
		| Levy account debited                    | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     | 0     |
		| SFA Levy employer budget                | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     | 0     |
		| SFA Levy co-funding budget              | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     | 0     |
		| SFA non Levy co-funding budget          | 540   | 540   | 540   | 540   | 540   | ... | 540   | 540   | 1620  | 0     |
		| SFA non-Levy additional payments budget | 120   | 120   | 120   | 1120  | 120   | ... | 120   | 120   | 1360  | 0     |

    And the transaction types for the payments are:
		| Payment type                 | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 06/18 | 07/18 | 08/18 | 09/18 |
		| On-program                   | 0     | 540   | 540   | 540   | 540   | ... | 540   | 540   | 540   | 0     |
		| Completion                   | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     | 1620  |
		| Balancing                    | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     | 0     |
		| Employer 16-18 incentive     | 0     | 0     | 0     | 0     | 500   | ... | 0     | 0     | 0     | 500   |
		| Provider 16-18 incentive     | 0     | 0     | 0     | 0     | 500   | ... | 0     | 0     | 0     | 500   |
		| Framework uplift on-program  | 0     | 120   | 120   | 120   | 120   | ... | 120   | 120   | 120   | 0     |
		| Framework uplift completion  | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     | 360   |
		| Framework uplift balancing   | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     | 0     |
		| Provider disadvantage uplift | 0     | 0     | 0     | 0     | 0     | ..  | 0     | 0     | 0     | 0     |

		
Scenario:AC4-Learner finishes on time, Price is less than Funding Band Maximum of �9,000
		
	When an ILR file is submitted with the following data:
		| ULN    | learner type                 | agreed price | start date | planned end date | actual end date | completion status | Framework Code | Programme Type | Pathway Code |
		| 123455 | 16-18 programme only non-DAS | 8250         | 06/08/2017 | 09/08/2018       | 10/08/2018      | Completed         | 403            | 2              | 1            |

	Then the provider earnings and payments break down as follows:
		| Type                                    | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 06/18 | 07/18 | 08/18 | 09/18 |
		| Provider Earned Total                   | 670   | 670   | 670   | 1670  | 670   | ... | 670   | 670   | 3010  | 0     |
		| Provider Earned from SFA                | 615   | 615   | 615   | 1615  | 615   | ... | 615   | 615   | 3845  | 0     |
		| Provider Earned from Employer           | 55    | 55    | 55    | 55    | 55    | ... | 55    | 55    | 165   | 0     |
		| Provider Paid by SFA                    | 0     | 615   | 615   | 615   | 1615  | ... | 615   | 615   | 615   | 2845  |
		| Payment due from Employer               | 0     | 55    | 55    | 55    | 55    | ... | 55    | 55    | 55    | 165   |
		| Levy account debited                    | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     | 0     |
		| SFA Levy employer budget                | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     | 0     |
		| SFA Levy co-funding budget              | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     | 0     |
		| SFA non Levy co-funding budget          | 495   | 495   | 495   | 495   | 495   | ... | 495   | 495   | 1485  | 0     |
		| SFA non-Levy additional payments budget | 120   | 120   | 120   | 1120  | 120   | ... | 120   | 120   | 1360  | 0     |

	  And the transaction types for the payments are:
		| Payment type                 | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 06/18 | 07/18 | 08/18 | 09/18 |
		| On-program                   | 0     | 495   | 495   | 495   | 495   | ... | 495   | 495   | 495   | 0     |
		| Completion                   | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     | 1485  |
		| Balancing                    | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     | 0     |
		| Employer 16-18 incentive     | 0     | 0     | 0     | 0     | 500   | ... | 0     | 0     | 0     | 500   |
		| Provider 16-18 incentive     | 0     | 0     | 0     | 0     | 500   | ... | 0     | 0     | 0     | 500   |
		| Framework uplift on-program  | 0     | 120   | 120   | 120   | 120   | ... | 120   | 120   | 120   | 0     |
		| Framework uplift completion  | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     | 360   |
		| Framework uplift balancing   | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     | 0     |
		| Provider disadvantage uplift | 0     | 0     | 0     | 0     | 0     | ..  | 0     | 0     | 0     | 0     |

Scenario:AC5- Payment for a non-DAS learner, lives in a disadvantaged postocde area - 1-10% most deprived, funding agreed within band maximum, UNDERTAKING APPRENTICESHIP FRAMEWORK The provider incentive for this postcode group is �600 split equally into 2 payments at 90 and 365 days. INELIGIBLE FOR APPRENTICESHIP STANDARDS
  
	When an ILR file is submitted with the following data:
		  | ULN       | learner type             | agreed price | start date | planned end date | actual end date | completion status | framework code | programme type | pathway code | home postcode deprivation |
		  | learner a | programme only non - DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        | 403            | 2              | 1            | 1-10%                     |
    Then the provider earnings and payments break down as follows:
		  | Type                                    | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 07/18 | 08/18 | 09/18 |
		  | Provider Earned Total                   | 1000  | 1000  | 1000  | 1300  | 1000  | ... | 1000  | 300   | 0     |
		  | Provider Paid by SFA                    | 0     | 900   | 900   | 900   | 1200  | ... | 900   | 900   | 300   |
		  | Payment due from Employer               | 0     | 100   | 100   | 100   | 100   | ... | 100   | 100   | 0     |
		  | Levy account debited                    | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA Levy employer budget                | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA levy co-funding budget              | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA non-levy co-funding budget          | 900   | 900   | 900   | 900   | 900   | ... | 900   | 0     | 0     |
		  | SFA non-levy additional payments budget | 0     | 0     | 0     | 300   | 0     | ... | 0     | 300   | 0     |
		  | SFA levy additional payments budget     | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
    And the transaction types for the payments are:
		  | Payment type                 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
		  | On-program                   | 900   | 900   | 900   | 900   | ... | 900   | 0     |
		  | Completion                   | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Balancing                    | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Provider disadvantage uplift | 0     | 0     | 0     | 300   | ... | 0     | 300   |
		  
Scenario:AC6- Payment for a non-DAS learner, lives in a disadvantaged postocde area - 11-20% most deprived, funding agreed within band maximum, UNDERTAKING APPRENTICESHIP FRAMEWORK
    #The provider incentive for this postcode group is �300 split equally into 2 payments at 90 and 365 days. INELIGIBLE FOR APPRENTICESHIP STANDARDS
	When an ILR file is submitted with the following data:
		  | ULN       | learner type           | agreed price | start date | planned end date | actual end date | completion status | framework code | programme type | pathway code | home postcode deprivation |
		  | learner a | programme only non-DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        | 403            | 2              | 1            | 11-20%                    |
      
	Then the provider earnings and payments break down as follows:
		  | Type                                     | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 07/18 | 08/18 | 09/18 |
		  | Provider Earned Total                    | 1000  | 1000  | 1000  | 1150  | 1000  | ... | 1000  | 150   | 0     |
		  | Provider Paid by SFA                     | 0     | 900   | 900   | 900   | 1050  | ... | 900   | 900   | 150   |
		  | Payment due from Employer                | 0     | 100   | 100   | 100   | 100   | ... | 100   | 100   | 0     |
		  | Levy account debited                     | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA Levy employer budget                 | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA levy co-funding budget               | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA non-levy co-funding budget           | 900   | 900   | 900   | 900   | 900   | ... | 900   | 0     | 0     |
		  | SFA non-levy  additional payments budget | 0     | 0     | 0     | 150   | 0     | ... | 0     | 150   | 0     |
		  | SFA levy additional payments budget      | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
	  And the transaction types for the payments are:
		  | Payment type                 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
		  | On-program                   | 900   | 900   | 900   | 900   | ... | 900   | 0     |
		  | Completion                   | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Balancing                    | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Provider disadvantage uplift | 0     | 0     | 0     | 150   | ... | 0     | 150   |

Scenario:AC7- Payment for a non-DAS learner, lives in a disadvantaged postocde area - 21-27% most deprived, funding agreed within band maximum, UNDERTAKING APPRENTICESHIP FRAMEWORK
    #The provider incentive for this postcode group is �200 split equally into 2 payments at 90 and 365 days. INELIGIBLE FOR APPRENITCESHIP STANDARDS
	When an ILR file is submitted with the following data:
		  | ULN       | learner type            | agreed price | start date | planned end date | actual end date | completion status | framework code | programme type | pathway code | home postcode deprivation |
		  | learner a | programme only non- DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        | 403            | 2              | 1            | 20-27%                    |
    Then the provider earnings and payments break down as follows:
		  | Type                                    | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 07/18 | 08/18 | 09/18 |
		  | Provider Earned Total                   | 1000  | 1000  | 1000  | 1100  | 1000  | ... | 1000  | 100   | 0     |
		  | Provider Paid by SFA                    | 0     | 900   | 900   | 900   | 1000  | ... | 900   | 900   | 100   |
		  | Payment due from Employer               | 0     | 100   | 100   | 100   | 100   | ... | 100   | 100   | 0     |
		  | Levy account debited                    | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA Levy employer budget                | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA levy co-funding budget              | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA non-levy co-funding budget          | 900   | 900   | 900   | 900   | 900   | ... | 900   | 0     | 0     |
		  | SFA non-levy additional payments budget | 0     | 0     | 0     | 100   | 0     | ... | 0     | 100   | 0     |
		  | SFA levy additional payments budget     | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
    And the transaction types for the payments are:
		  | Payment type                 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
		  | On-program                   | 900   | 900   | 900   | 900   | ... | 900   | 0     |
		  | Completion                   | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Balancing                    | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Provider disadvantage uplift | 0     | 0     | 0     | 100   | ... | 0     | 100   |

 Scenario:AC8- Payment for a non-DAS learner, does not live in a disadvantaged postcode area - no uplift earned, despite them doing a framework
  
	When an ILR file is submitted with the following data:
		  | ULN       | learner type            | agreed price | start date | planned end date | actual end date | completion status | framework code | programme type | pathway code | home postcode deprivation |
		  | learner a | programme only non- DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        | 403            | 2              | 1            | not deprived              |
    Then the provider earnings and payments break down as follows:
		  | Type                                    | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 07/18 | 08/18 | 09/18 |
		  | Provider Earned Total                   | 1000  | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     | 0     |
		  | Provider Paid by SFA                    | 0     | 900   | 900   | 900   | 900   | ... | 900   | 900   | 0     |
		  | Payment due from Employer               | 0     | 100   | 100   | 100   | 100   | ... | 100   | 100   | 0     |
		  | Levy account debited                    | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA Levy employer budget                | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA levy co-funding budget              | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA non-levy co-funding budget          | 900   | 900   | 900   | 900   | 900   | ... | 900   | 0     | 0     |
		  | SFA non-levy additional payments budget | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA levy additional payments budget     | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
    And the transaction types for the payments are:
		  | Payment type                 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
		  | On-program                   | 900   | 900   | 900   | 900   | ... | 900   | 0     |
		  | Completion                   | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Balancing                    | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Provider disadvantage uplift | 0     | 0     | 0     | 0     | ... | 0     | 0     |


@MathsAndEnglishNonDas
Scenario:AC9- Maths and English payments for a non-das learner finishing on time, funding agreed within band maximum, planned duration is same as programme (assumes both start and finish at same time)
    When an ILR file is submitted with the following data:
        | ULN       | learner type           | agreed price | start date | planned end date | actual end date | completion status | aim type         | aim rate | framework code | programme type | pathway code |
        | learner a | programme only non-DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        | programme        |          | 403            | 2              | 1            |
        | learner a | programme only non-DAS |              | 06/08/2017 | 08/08/2018       | 08/08/2018      | completed         | maths or english | 471      | 403            | 2              | 1            |
    Then the provider earnings and payments break down as follows:
        | Type                                    | 08/17   | 09/17   | 10/17   | 11/17   | 12/17   | ... | 07/18   | 08/18  | 09/18 |
        | Provider Earned Total                   | 1039.25 | 1039.25 | 1039.25 | 1039.25 | 1039.25 | ... | 1039.25 | 0      | 0     |
        | Provider Earned from SFA                | 939.25  | 939.25  | 939.25  | 939.25  | 939.25  | ... | 939.25  | 0      | 0     |
        | Provider Earned from Employer           | 100     | 100     | 100     | 100     | 100     | ... | 100     | 0      | 0     |
        | Provider Paid by SFA                    | 0       | 939.25  | 939.25  | 939.25  | 939.25  | ... | 939.25  | 939.25 | 0     |
        | Payment due from Employer               | 0       | 100     | 100     | 100     | 100     | ... | 100     | 100    | 0     |
        | Levy account debited                    | 0       | 0       | 0       | 0       | 0       | ... | 0       | 0      | 0     |
        | SFA Levy employer budget                | 0       | 0       | 0       | 0       | 0       | ... | 0       | 0      | 0     |
        | SFA Levy co-funding budget              | 0       | 0       | 0       | 0       | 0       | ... | 0       | 0      | 0     |
        | SFA non-Levy co-funding budget          | 900     | 900     | 900     | 900     | 900     | ... | 900     | 0      | 0     |
        | SFA non-Levy additional payments budget | 39.25   | 39.25   | 39.25   | 39.25   | 39.25   | ... | 39.25   | 0      | 0     |
    And the transaction types for the payments are:
        | Payment type                   | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
        | On-program                     | 900   | 900   | 900   | 900   | ... | 900   | 0     |
        | Completion                     | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Balancing                      | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Employer 16-18 incentive       | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Provider 16-18 incentive       | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | English and maths on programme | 39.25 | 39.25 | 39.25 | 39.25 | ... | 39.25 | 0     |
        | English and maths Balancing    | 0     | 0     | 0     | 0     | ... | 0     | 0     |


@MathsAndEnglishDas
Scenario:AC10- Maths and English payments for a das learner finishing on time, funding agreed within band maximum, planned duration is same as programme (assumes both start and finish at same time)
    Given levy balance > agreed price for all months
    And the following commitments exist:
        | commitment Id | ULN       | start date | end date   | agreed price | framework code | programme type | pathway code | status | effective from | effective to |
        | 1             | learner a | 01/08/2017 | 01/08/2018 | 15000        | 403            | 2              | 1            | active | 01/08/2017     |              |
    When an ILR file is submitted with the following data:
        | ULN       | learner type       | agreed price | start date | planned end date | actual end date | completion status | aim type         | aim rate | framework code | programme type | pathway code |
        | learner a | programme only DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        | programme        |          | 403            | 2              | 1            |
        | learner a | programme only DAS |              | 06/08/2017 | 08/08/2018       | 08/08/2018      | completed         | maths or english | 471      | 403            | 2              | 1            |
    Then the provider earnings and payments break down as follows:
        | Type                                | 08/17   | 09/17   | 10/17   | 11/17   | 12/17   | ... | 07/18   | 08/18   | 09/18 |
        | Provider Earned Total               | 1039.25 | 1039.25 | 1039.25 | 1039.25 | 1039.25 | ... | 1039.25 | 0       | 0     |
        | Provider Earned from SFA            | 1039.25 | 1039.25 | 1039.25 | 1039.25 | 1039.25 | ... | 1039.25 | 0       | 0     |
        | Provider Earned from Employer       | 0       | 0       | 0       | 0       | 0       | ... | 0       | 0       | 0     |
        | Provider Paid by SFA                | 0       | 1039.25 | 1039.25 | 1039.25 | 1039.25 | ... | 1039.25 | 1039.25 | 0     |
        | Payment due from Employer           | 0       | 0       | 0       | 0       | 0       | ... | 0       | 0       | 0     |
        | Levy account debited                | 0       | 1000    | 1000    | 1000    | 1000    | ... | 1000    | 1000    | 0     |
        | SFA Levy employer budget            | 1000    | 1000    | 1000    | 1000    | 1000    | ... | 1000    | 0       | 0     |
        | SFA Levy co-funding budget          | 0       | 0       | 0       | 0       | 0       | ... | 0       | 0       | 0     |
        | SFA Levy additional payments budget | 39.25   | 39.25   | 39.25   | 39.25   | 39.25   | ... | 39.25   | 0       | 0     |
        | SFA non-Levy co-funding budget      | 0       | 0       | 0       | 0       | 0       | ... | 0       | 0       | 0     |
    And the transaction types for the payments are:
        | Payment type                   | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
        | On-program                     | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     |
        | Completion                     | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Balancing                      | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Employer 16-18 incentive       | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Provider 16-18 incentive       | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | English and maths on programme | 39.25 | 39.25 | 39.25 | 39.25 | ... | 39.25 | 0     |
        | English and maths Balancing    | 0     | 0     | 0     | 0     | ... | 0     | 0     |


Scenario:AC11- Payment for a DAS learner, lives in a disadvantaged postocde area - 01-10% most deprived, employer has sufficient levy funds in account, funding agreed within band maximum, UNDERTAKING APPRENTICESHIP FRAMEWORK
    #The provider incentive for this postcode group is �600 split equally into 2 payments at 90 and 365 days.INELIGIBLE FOR APPRENTICESHIP STANDARDS
	Given levy balance > agreed price for all months
    And the following commitments exist:
		  | commitment ID | version ID | ULN       | start date  | end date   | framework code | programme type | pathway code | agreed price | status   |
		  | 1             | 1          | learner a | 01/08/2017  | 01/08/2018 | 403            | 2              | 1            | 15000        | active   |
	When an ILR file is submitted with the following data:
		  | ULN       | learner type       | agreed price | start date | planned end date | actual end date | completion status | framework code | programme type | pathway code | home postcode deprivation |
		  | learner a | programme only DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        | 403            | 2              | 1            | 1-10%                     |
    Then the provider earnings and payments break down as follows:
		  | Type                                    | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 07/18 | 08/18 | 09/18 |
		  | Provider Earned Total                   | 1000  | 1000  | 1000  | 1300  | 1000  | ... | 1000  | 300   | 0     |
		  | Provider Paid by SFA                    | 0     | 1000  | 1000  | 1000  | 1300  | ... | 1000  | 1000  | 300   |
		  | Payment due from Employer               | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | Levy account debited                    | 0     | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 1000  | 0     |
		  | SFA Levy employer budget                | 1000  | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     | 0     |
		  | SFA levy co-funding budget              | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA non-levy co-funding budget          | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA non-levy additional payments budget | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA levy additional payments budget     | 0     | 0     | 0     | 300   | 0     | ... | 0     | 300   | 0     |
	And the transaction types for the payments are:
		  | Payment type                 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
		  | On-program                   | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     |
		  | Completion                   | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Balancing                    | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Provider disadvantage uplift | 0     | 0     | 0     | 300   | ... | 0     | 300   |

Scenario:AC12- Payment for a DAS learner, lives in a disadvantaged postocde area - 11-20% most deprived, employer has sufficient levy funds in account, funding agreed within band maximum, UNDERTAKING APPRENTICESHIP FRAMEWORK
    #The provider incentive for this postcode group is �300 split equally into 2 payments at 90 and 365 days. INELIGIBLE FOR APPRENITCESHIP STANDARDS
	Given levy balance > agreed price for all months
    And the following commitments exist:
		  | commitment ID | version ID | ULN       | start date  | end date   | framework code | programme type | pathway code | agreed price | status   |
		  | 1             | 1          | learner a | 01/08/2017  | 01/08/2018 | 403            | 2              | 1            | 15000        | active   |
	When an ILR file is submitted with the following data:
		  | ULN       | learner type       | agreed price | start date | planned end date | actual end date | completion status | framework code | programme type | pathway code | home postcode deprivation |
		  | learner a | programme only DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        | 403            | 2              | 1            | 11-20%                    |
    Then the provider earnings and payments break down as follows:
		  | Type                                    | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 07/18 | 08/18 | 09/18 |
		  | Provider Earned Total                   | 1000  | 1000  | 1000  | 1150  | 1000  | ... | 1000  | 150   | 0     |
		  | Provider Paid by SFA                    | 0     | 1000  | 1000  | 1000  | 1500  | ... | 1000  | 1000  | 150   |
		  | Payment due from Employer               | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | Levy account debited                    | 0     | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 1000  | 0     |
		  | SFA Levy employer budget                | 1000  | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     | 0     |
		  | SFA levy co-funding budget              | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA non-levy co-funding budget          | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA non-levy additional payments budget | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA levy additional payments budget     | 0     | 0     | 0     | 150   | 0     | ... | 0     | 150   | 0     |
	And the transaction types for the payments are:
		  | Payment type                 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
		  | On-program                   | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     |
		  | Completion                   | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Balancing                    | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Provider disadvantage uplift | 0     | 0     | 0     | 150   | ... | 0     | 150   |

		  	  
Scenario:AC13- Payment for a DAS learner, lives in a disadvantaged postocde area - 21-27% most deprived, employer has sufficient levy funds in account, funding agreed within band maximum, UNDERTAKING APPRENTICESHIP FRAMEWORK
    #The provider incentive for this postcode group is �200 split equally into 2 payments at 90 and 365 days. INELIGIBLE FOR APPRENITCESHIP STANDARDS
  	Given levy balance > agreed price for all months
    And the following commitments exist:
		  | commitment ID | version ID | ULN       | start date  | end date   | framework code | programme type | pathway code | agreed price | status   | 
		  | 1             | 1          | learner a | 01/08/2017  | 01/08/2018 | 403            | 2              | 1            | 15000        | active   | 

	When an ILR file is submitted with the following data:
		  | ULN       | learner type       | agreed price | start date | planned end date | actual end date | completion status | framework code | programme type | pathway code | home postcode deprivation |
		  | learner a | programme only DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        | 403            | 2              | 1            | 20-27%                    |
      
    Then the provider earnings and payments break down as follows:
		  | Type                                    | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 07/18 | 08/18 | 09/18 |
		  | Provider Earned Total                   | 1000  | 1000  | 1000  | 1100  | 1000  | ... | 1000  | 100   | 0     |
		  | Provider Paid by SFA                    | 0     | 1000  | 1000  | 1000  | 1100  | ... | 1000  | 1000  | 100   |
		  | Payment due from Employer               | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | Levy account debited                    | 0     | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 1000  | 0     |
		  | SFA Levy employer budget                | 1000  | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     | 0     |
		  | SFA levy co-funding budget              | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA non-levy co-funding budget          | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA non-levy additional payments budget | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA levy  additional payments budget    | 0     | 0     | 0     | 100   | 0     | ... | 0     | 100   | 0     |
  And the transaction types for the payments are:
		  | Payment type                 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
		  | On-program                   | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     |
		  | Completion                   | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Balancing                    | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Provider disadvantage uplift | 0     | 0     | 0     | 100   | ... | 0     | 100   |

Scenario:AC14- Payment for a DAS learner, does not live in a disadvantaged postocde area - employer has sufficient levy funds in account, funding agreed within band maximum, UNDERTAKING APPRENTICESHIP FRAMEWORK
   
	Given levy balance > agreed price for all months
    And the following commitments exist:
		  | commitment ID | version ID | ULN       | start date  | end date   | framework code | programme type | pathway code | agreed price | status   | 
		  | 1             | 1          | learner a | 01/08/2017  | 01/08/2018 | 403            | 2              | 1            | 15000        | active   | 
	When an ILR file is submitted with the following data:
		  | ULN       | learner type       | agreed price | start date | planned end date | actual end date | completion status | framework code | programme type | pathway code | home postcode deprivation |
		  | learner a | programme only DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        | 403            | 2              | 1            | not deprived              |
    Then the provider earnings and payments break down as follows:
		  | Type                                    | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 07/18 | 08/18 | 09/18 |
		  | Provider Earned Total                   | 1000  | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     | 0     |
		  | Provider Paid by SFA                    | 0     | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 1000  | 0     |
		  | Payment due from Employer               | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | Levy account debited                    | 0     | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 1000  | 0     |
		  | SFA Levy employer budget                | 1000  | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     | 0     |
		  | SFA levy co-funding budget              | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA non-levy co-funding budget          | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA non-levy additional payments budget | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
		  | SFA levy additional payments budget     | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
    And the transaction types for the payments are:
		  | Payment type                 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
		  | On-program                   | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     |
		  | Completion                   | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Balancing                    | 0     | 0     | 0     | 0     | ... | 0     | 0     |
		  | Provider disadvantage uplift | 0     | 0     | 0     | 0     | ... | 0     | 0     |


@DisadvantageUpliftsNonDasForStandard
Scenario: 624-AC01-Payment for a non-DAS learner, lives in a disadvantaged postocde area - 1-10% most deprived, funding agreed within band maximum, undertaking apprenticeship standard
	When an ILR file is submitted with the following data:
        | ULN       | learner type             | agreed price | start date | planned end date | actual end date | completion status | standard code | home postcode deprivation |
        | learner a | programme only non - DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        | 50            | 1-10%                     |
    Then the provider earnings and payments break down as follows:
        | Type                                    | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 07/18 | 08/18 | 09/18 |
        | Provider Earned Total                   | 1000  | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     | 0     |
        | Provider Paid by SFA                    | 0     | 900   | 900   | 900   | 900   | ... | 900   | 900   | 0     |
        | Payment due from Employer               | 0     | 100   | 100   | 100   | 100   | ... | 100   | 100   | 0     |
        | Levy account debited                    | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA Levy employer budget                | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA Levy co-funding budget              | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA non-Levy co-funding budget          | 900   | 900   | 900   | 900   | 900   | ... | 900   | 0     | 0     |
        | SFA non-Levy additional payments budget | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA Levy additional payments budget     | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
    And the transaction types for the payments are:
        | Payment type                 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
        | On-program                   | 900   | 900   | 900   | 900   | ... | 900   | 0     |
        | Completion                   | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Balancing                    | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Provider disadvantage uplift | 0     | 0     | 0     | 0     | ... | 0     | 0     |


@DisadvantageUpliftsNonDasForStandard
Scenario: 624-AC02-Payment for a non-DAS learner, lives in a disadvantaged postocde area - 11-20% most deprived, funding agreed within band maximum, undertaking apprenticeship standard
	When an ILR file is submitted with the following data:
        | ULN       | learner type             | agreed price | start date | planned end date | actual end date | completion status | standard code | home postcode deprivation |
        | learner a | programme only non - DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        | 50            | 11-20%                    |
    Then the provider earnings and payments break down as follows:
        | Type                                    | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 07/18 | 08/18 | 09/18 |
        | Provider Earned Total                   | 1000  | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     | 0     |
        | Provider Paid by SFA                    | 0     | 900   | 900   | 900   | 900   | ... | 900   | 900   | 0     |
        | Payment due from Employer               | 0     | 100   | 100   | 100   | 100   | ... | 100   | 100   | 0     |
        | Levy account debited                    | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA Levy employer budget                | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA Levy co-funding budget              | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA non-Levy co-funding budget          | 900   | 900   | 900   | 900   | 900   | ... | 900   | 0     | 0     |
        | SFA non-Levy additional payments budget | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA Levy additional payments budget     | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
    And the transaction types for the payments are:
        | Payment type                 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
        | On-program                   | 900   | 900   | 900   | 900   | ... | 900   | 0     |
        | Completion                   | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Balancing                    | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Provider disadvantage uplift | 0     | 0     | 0     | 0     | ... | 0     | 0     |


@DisadvantageUpliftsNonDasForStandard
Scenario: 624-AC03-Payment for a non-DAS learner, lives in a disadvantaged postocde area - 21-27% most deprived, funding agreed within band maximum, undertaking apprenticeship standard
	When an ILR file is submitted with the following data:
        | ULN       | learner type             | agreed price | start date | planned end date | actual end date | completion status | standard code | home postcode deprivation |
        | learner a | programme only non - DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        | 50            | 21-27%                    |
    Then the provider earnings and payments break down as follows:
        | Type                                    | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 07/18 | 08/18 | 09/18 |
        | Provider Earned Total                   | 1000  | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     | 0     |
        | Provider Paid by SFA                    | 0     | 900   | 900   | 900   | 900   | ... | 900   | 900   | 0     |
        | Payment due from Employer               | 0     | 100   | 100   | 100   | 100   | ... | 100   | 100   | 0     |
        | Levy account debited                    | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA Levy employer budget                | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA Levy co-funding budget              | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA non-Levy co-funding budget          | 900   | 900   | 900   | 900   | 900   | ... | 900   | 0     | 0     |
        | SFA non-Levy additional payments budget | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA Levy additional payments budget     | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
    And the transaction types for the payments are:
        | Payment type                 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
        | On-program                   | 900   | 900   | 900   | 900   | ... | 900   | 0     |
        | Completion                   | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Balancing                    | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Provider disadvantage uplift | 0     | 0     | 0     | 0     | ... | 0     | 0     |


@DisadvantageUpliftsNonDasForStandard
Scenario: 624-AC04-Payment for a non-DAS learner, does not live in a disadvantaged postocde area, funding agreed within band maximum, undertaking apprenticeship standard
	When an ILR file is submitted with the following data:
        | ULN       | learner type             | agreed price | start date | planned end date | actual end date | completion status | standard code | home postcode deprivation |
        | learner a | programme only non - DAS | 15000        | 06/08/2017 | 08/08/2018       |                 | continuing        | 50            | not deprived              |
    Then the provider earnings and payments break down as follows:
        | Type                                    | 08/17 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 07/18 | 08/18 | 09/18 |
        | Provider Earned Total                   | 1000  | 1000  | 1000  | 1000  | 1000  | ... | 1000  | 0     | 0     |
        | Provider Paid by SFA                    | 0     | 900   | 900   | 900   | 900   | ... | 900   | 900   | 0     |
        | Payment due from Employer               | 0     | 100   | 100   | 100   | 100   | ... | 100   | 100   | 0     |
        | Levy account debited                    | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA Levy employer budget                | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA Levy co-funding budget              | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA non-Levy co-funding budget          | 900   | 900   | 900   | 900   | 900   | ... | 900   | 0     | 0     |
        | SFA non-Levy additional payments budget | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        | SFA Levy additional payments budget     | 0     | 0     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
    And the transaction types for the payments are:
        | Payment type                 | 09/17 | 10/17 | 11/17 | 12/17 | ... | 08/18 | 09/18 |
        | On-program                   | 900   | 900   | 900   | 900   | ... | 900   | 0     |
        | Completion                   | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Balancing                    | 0     | 0     | 0     | 0     | ... | 0     | 0     |
        | Provider disadvantage uplift | 0     | 0     | 0     | 0     | ... | 0     | 0     |