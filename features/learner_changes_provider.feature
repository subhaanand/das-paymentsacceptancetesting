Feature: Apprentice changes provider and there is a gap between commitments
    
    Scenario: Apprentice changes provider but remains with the same employer, and there is a gap between the two learning spells
        Given The learner is programme only DAS
        And levy balance > agreed price for all months
        And the following commitments exist:
            | commitment Id | version Id | Provider   | ULN       | price effective date | planned end date | agreed price | status    | effective from | effective to |
            | 1             | 1          | provider a | learner a | 01/08/2017           | 01/08/2018       | 7500         | active    | 01/08/2017     | 04/03/2018   |
            | 1             | 2          | provider a | learner a | 01/08/2017           | 01/08/2018       | 7500         | withdrawn | 05/03/2018     |              |
            | 2             | 1          | provider b | learner a | 01/06/2018           | 01/11/2018       | 4500         | active    | 06/06/2018     |              |
        
        When the providers submit the following ILR files:
            | Provider   | ULN       | start date | planned end date | actual end date | completion status | Total training price | Total training price effective date | Total assessment price | Total assessment price effective date |
            | provider a | learner a | 06/08/2017 | 08/08/2018       | 04/03/2018      | Cancelled         | 6000                 | 06/08/2017                          | 1500                   | 06/08/2017                            |
            | provider b | learner a | 06/06/2018 | 20/11/2018       |                 | continuing        | 3000                 | 06/06/2018                          | 1500                   | 06/06/2018                            |
        
        Then the data lock status will be as follows:
            | type                | 08/17 - 02/18 | 06/18 onwards |  
            | matching commitment | 1             | 2             |
        
        And the earnings and payments break down for provider a is as follows:
            | Type                           | 08/17 | 09/17 | 10/17 | ... | 02/18 | 03/18 |
            | Provider Earned Total          | 500   | 500   | 500   | ... | 500   | 0     |
            | Provider Earned from SFA       | 500   | 500   | 500   | ... | 500   | 0     |
            | Provider Earned from Employer  | 0     | 0     | 0     | ... | 0     | 0     |
            | Provider Paid by SFA           | 0     | 500   | 500   | ... | 500   | 500   |
            | Payment due from Employer      | 0     | 0     | 0     | ... | 0     | 0     |
            | Levy account debited           | 0     | 500   | 500   | ... | 500   | 500   |
            | SFA Levy employer budget       | 500   | 500   | 500   | ... | 500   | 0     |
            | SFA Levy co-funding budget     | 0     | 0     | 0     | ... | 0     | 0     |
            | SFA non-Levy co-funding budget | 0     | 0     | 0     | ... | 0     | 0     |
        
        And the earnings and payments break down for provider b is as follows:
            | Type                           | 06/18 | 07/18 | 08/18 | 09/18 | 10/18 | 11/18 |
            | Provider Earned Total          | 720   | 720   | 720   | 720   | 720   | 0     |
            | Provider Earned from SFA       | 720   | 720   | 720   | 720   | 720   | 0     |
            | Provider Earned from Employer  | 0     | 0     | 0     | 0     | 0     | 0     |
            | Provider Paid by SFA           | 0     | 720   | 720   | 720   | 720   | 720   |
            | Payment due from Employer      | 0     | 0     | 0     | 0     | 0     | 0     |
            | Levy account debited           | 0     | 720   | 720   | 720   | 720   | 720   |
            | SFA Levy employer budget       | 720   | 720   | 720   | 720   | 720   | 0     |
            | SFA Levy co-funding budget     | 0     | 0     | 0     | 0     | 0     | 0     |
            | SFA non-Levy co-funding budget | 0     | 0     | 0     | 0     | 0     | 0     |


    Scenario: Apprentice changes provider but remains with the same employer
        Given The learner is programme only DAS
        And levy balance > agreed price for all months
        And the following commitments exist:
            | commitment Id | version Id | Provider   | ULN       | price effective date | planned end date | agreed price | status    | effective from | effective to |
            | 1             | 1          | provider a | learner a | 01/08/2017           | 01/08/2018       | 7500         | active    | 01/08/2017     | 04/03/2018   |
            | 1             | 2          | provider a | learner a | 01/08/2017           | 01/08/2018       | 7500         | withdrawn | 05/03/2018     |              |
            | 2             | 1          | provider b | learner a | 05/03/2018           | 01/08/2018       | 4500         | active    | 05/03/2018     |              |
        When the providers submit the following ILR files:
            | Provider   | ULN       | start date | planned end date | actual end date | completion status | Total training price | Total training price effective date | Total assessment price | Total assessment price effective date |
            | provider a | learner a | 06/08/2017 | 08/08/2018       | 04/03/2018      | withdrawn         | 6000                 | 06/08/2017                          | 1500                   | 06/08/2017                            |
            | provider b | learner a | 05/03/2018 | 20/08/2018       |                 | continuing        | 3000                 | 05/03/2018                          | 1500                   | 05/03/2018                            |
        Then the data lock status will be as follows:
            | type                | 08/17 - 02/18 | 03/18 onwards |
            | matching commitment | 1             | 2             |
        And the earnings and payments break down for provider a is as follows:
            | Type                           | 08/17 | 09/17 | 10/17 | ... | 02/18 | 03/18 |
            | Provider Earned Total          | 500   | 500   | 500   | ... | 500   | 0     |
            | Provider Earned from SFA       | 500   | 500   | 500   | ... | 500   | 0     |
            | Provider Earned from Employer  | 0     | 0     | 0     | ... | 0     | 0     |
            | Provider Paid by SFA           | 0     | 500   | 500   | ... | 500   | 500   |
            | Payment due from Employer      | 0     | 0     | 0     | ... | 0     | 0     |
            | Levy account debited           | 0     | 500   | 500   | ... | 500   | 500   |
            | SFA Levy employer budget       | 500   | 500   | 500   | ... | 500   | 0     |
            | SFA Levy co-funding budget     | 0     | 0     | 0     | ... | 0     | 0     |
            | SFA non-Levy co-funding budget | 0     | 0     | 0     | ... | 0     | 0     |
        And the earnings and payments break down for provider b is as follows:
            | Type                           | 03/18 | 04/18 | 05/18 | 06/18 | 07/18 | 08/18 |
            | Provider Earned Total          | 720   | 720   | 720   | 720   | 720   | 0     |
            | Provider Earned from SFA       | 720   | 720   | 720   | 720   | 720   | 0     |
            | Provider Earned from Employer  | 0     | 0     | 0     | 0     | 0     | 0     |
            | Provider Paid by SFA           | 0     | 720   | 720   | 720   | 720   | 720   |
            | Payment due from Employer      | 0     | 0     | 0     | 0     | 0     | 0     |
            | Levy account debited           | 0     | 720   | 720   | 720   | 720   | 720   |
            | SFA Levy employer budget       | 720   | 720   | 720   | 720   | 720   | 0     |
            | SFA Levy co-funding budget     | 0     | 0     | 0     | 0     | 0     | 0     |
            | SFA non-Levy co-funding budget | 0     | 0     | 0     | 0     | 0     | 0     |


    Scenario: Apprentice changes provider but remains with the same employer, ILR changes after the new commitment is in place
        Given The learner is programme only DAS
        And levy balance > agreed price for all months
        And the following commitments exist:
            | commitment Id | version Id | Provider   | ULN       | price effective date | planned end date | agreed price | status    | effective from | effective to |
            | 1             | 1          | provider a | learner a | 01/08/2017           | 01/08/2018       | 7500         | active    | 01/08/2017     | 04/03/2018   |
            | 1             | 2          | provider a | learner a | 01/08/2017           | 01/08/2018       | 7500         | withdrawn | 05/03/2018     |              |
            | 2             | 1          | provider b | learner a | 05/03/2018           | 01/08/2018       | 4500         | active    | 05/03/2018     |              |
        When the providers submit the following ILR files:
            | Provider   | ULN       | start date | planned end date | actual end date | completion status | Total training price | Total training price effective date | Total assessment price | Total assessment price effective date |
            | provider a | learner a | 06/08/2017 | 08/08/2018       | 04/04/2018      | withdrawn         | 6000                 | 06/08/2017                          | 1500                   | 06/08/2017                            |
            | provider b | learner a | 05/04/2018 | 08/08/2018       |                 | continuing        | 3000                 | 05/04/2018                          | 1500                   | 05/04/2018                            |
        Then the data lock status will be as follows:
            | type                | 08/17 - 03/18 | 04/18 onwards |
            | matching commitment | 1             | 2             |
        And the earnings and payments break down for provider a is as follows:
            | Type                           | 08/17 | 09/17 | 10/17 | ... | 02/18 | 03/18 | 04/18 |
            | Provider Earned Total          | 500   | 500   | 500   | ... | 500   | 500   | 0     |
            | Provider Earned from SFA       | 500   | 500   | 500   | ... | 500   | 0     | 0     |
            | Provider Earned from Employer  | 0     | 0     | 0     | ... | 0     | 0     | 0     |
            | Provider Paid by SFA           | 0     | 500   | 500   | ... | 500   | 500   | 0     |
            | Payment due from Employer      | 0     | 0     | 0     | ... | 0     | 0     | 0     |
            | Levy account debited           | 0     | 500   | 500   | ... | 500   | 500   | 0     |
            | SFA Levy employer budget       | 500   | 500   | 500   | ... | 500   | 0     | 0     |
            | SFA Levy co-funding budget     | 0     | 0     | 0     | ... | 0     | 0     | 0     |
            | SFA non-Levy co-funding budget | 0     | 0     | 0     | ... | 0     | 0     | 0     |
        And the earnings and payments break down for provider b is as follows:
            | Type                           | 04/18 | 05/18 | 06/18 | 07/18 | 08/18 |
            | Provider Earned Total          | 900   | 900   | 900   | 900   | 0     |
            | Provider Earned from SFA       | 900   | 900   | 900   | 900   | 0     |
            | Provider Earned from Employer  | 0     | 0     | 0     | 0     | 0     |
            | Provider Paid by SFA           | 0     | 900   | 900   | 900   | 900   |
            | Payment due from Employer      | 0     | 0     | 0     | 0     | 0     |
            | Levy account debited           | 0     | 900   | 900   | 900   | 900   |
            | SFA Levy employer budget       | 900   | 900   | 900   | 900   | 0     |
            | SFA Levy co-funding budget     | 0     | 0     | 0     | 0     | 0     |
            | SFA non-Levy co-funding budget | 0     | 0     | 0     | 0     | 0     |


    Scenario: Apprentice changes provider but remains with the same employer, ILR changes before the new commitment is in place
        Given The learner is programme only DAS
        And levy balance > agreed price for all months
        And the following commitments exist:
            | commitment Id | version Id | Provider   | ULN       | price effective date | planned end date | agreed price | status    | effective from | effective to |
            | 1             | 1          | provider a | learner a | 01/08/2017           | 01/08/2018       | 7500         | active    | 01/08/2017     | 04/03/2018   |
            | 1             | 2          | provider a | learner a | 01/08/2017           | 01/08/2018       | 7500         | withdrawn | 05/03/2018     |              |
            | 2             | 1          | provider b | learner a | 05/03/2018           | 01/08/2018       | 4500         | active    | 05/03/2018     |              |
        When the providers submit the following ILR files:
            | Provider   | ULN       | start date | planned end date | actual end date | completion status | Total training price | Total training price effective date | Total assessment price | Total assessment price effective date |
            | provider a | learner a | 06/08/2017 | 08/08/2018       | 04/02/2018      | withdrawn         | 6000                 | 06/08/2017                          | 1500                   | 06/08/2017                            |
            | provider b | learner a | 05/02/2018 | 20/08/2018       |                 | continuing        | 3000                 | 05/02/2018                          | 1500                   | 05/02/2018                            |
        Then the data lock status will be as follows:
            | type                | 08/17 - 01/18 | 02/18 onwards |
            | matching commitment | 1             |               |
        And the earnings and payments break down for provider a is as follows:
            | Type                           | 08/17 | 09/17 | 10/17 | ... | 01/18 | 02/18 |
            | Provider Earned Total          | 500   | 500   | 500   | ... | 500   | 0     |
            | Provider Earned from SFA       | 500   | 500   | 500   | ... | 500   | 0     |
            | Provider Earned from Employer  | 0     | 0     | 0     | ... | 0     | 0     |
            | Provider Paid by SFA           | 0     | 500   | 500   | ... | 500   | 500   |
            | Payment due from Employer      | 0     | 0     | 0     | ... | 0     | 0     |
            | Levy account debited           | 0     | 500   | 500   | ... | 500   | 500   |
            | SFA Levy employer budget       | 500   | 500   | 500   | ... | 500   | 0     |
            | SFA Levy co-funding budget     | 0     | 0     | 0     | ... | 0     | 0     |
            | SFA non-Levy co-funding budget | 0     | 0     | 0     | ... | 0     | 0     |
        And the earnings and payments break down for provider b is as follows:
            | Type                           | 02/18 | 03/18 | 04/18 | ... | 07/18 | 08/18 |
            | Provider Earned Total          | 600   | 600   | 600   | ... | 600   | 0     |
            | Provider Earned from SFA       | 0     | 0     | 0     | ... | 0     | 0     |
            | Provider Earned from Employer  | 0     | 0     | 0     | ... | 0     | 0     |
            | Provider Paid by SFA           | 0     | 0     | 0     | ... | 0     | 0     |
            | Payment due from Employer      | 0     | 0     | 0     | ... | 0     | 0     |
            | Levy account debited           | 0     | 0     | 0     | ... | 0     | 0     |
            | SFA Levy employer budget       | 0     | 0     | 0     | ... | 0     | 0     |
            | SFA Levy co-funding budget     | 0     | 0     | 0     | ... | 0     | 0     |
            | SFA non-Levy co-funding budget | 0     | 0     | 0     | ... | 0     | 0     |