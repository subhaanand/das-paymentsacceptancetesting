﻿using System.Collections.Generic;
using System.Linq;
using SFA.DAS.Payments.AcceptanceTests.Refactoring.ReferenceDataModels;
using SFA.DAS.Payments.AcceptanceTests.Refactoring.ResultsDataModels;

namespace SFA.DAS.Payments.AcceptanceTests.Refactoring.Assertions.TransactionTypeRules
{
    public class EmployerEarnedFor16To18IncentiveRule : TransactionTypeRuleBase
    {
        protected override IEnumerable<PaymentResult> FilterPayments(PeriodValue period, IEnumerable<LearnerResults> submissionResults)
        {
            var employerPeriod = (EmployerAccountPeriodValue)period;
            var earningPeriod = employerPeriod.PeriodName.ToPeriodDateTime().AddMonths(-1).ToPeriodName();
            return submissionResults.SelectMany(r => r.Payments).Where(p => p.EmployerAccountId == employerPeriod.EmployerAccountId
                                                                         && p.DeliveryPeriod == earningPeriod
                                                                         && (p.TransactionType == TransactionType.First16To18EmployerIncentive || p.TransactionType == TransactionType.Second16To18EmployerIncentive));
        }

        protected override string FormatAssertionFailureMessage(PeriodValue period, decimal actualPaymentInPeriod)
        {
            var employerPeriod = (EmployerAccountPeriodValue)period;
            var specPeriod = employerPeriod.PeriodName.ToPeriodDateTime().AddMonths(-1).ToPeriodName();
            return $"Expected Employer {employerPeriod.EmployerAccountId} to be paid {period.Value} in {specPeriod} for 16-18 incentive but was actually paid {actualPaymentInPeriod}";
        }
    }
}