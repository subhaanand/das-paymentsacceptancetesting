﻿namespace SFA.DAS.Payments.AcceptanceTests.Refactoring.DataCollectors.Entities
{
    public class PaymentResultEntity
    {
        public long Ukprn { get; set; }
        public long Uln { get; set; }
        public string CalculationPeriod { get; set; }
        public string DeliveryPeriod { get; set; }
        public int FundingSource { get; set; }
        public int TransactionType { get; set; }
        public decimal Amount { get; set; }
        public int ContractType { get; set; }


    }
}
