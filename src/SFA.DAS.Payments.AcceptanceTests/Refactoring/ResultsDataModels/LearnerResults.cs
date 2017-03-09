﻿using System.Collections.Generic;

namespace SFA.DAS.Payments.AcceptanceTests.Refactoring.ResultsDataModels
{
    public class LearnerResults
    {
        public string ProviderId { get; set; }
        public string LearnerId { get; set; }
        public List<EarningsResult> Earnings { get; set; }
        public List<PaymentResult> Payments { get; set; }
        public List<DataLockPeriodResults> DataLockResults { get; set; }
    }
}
