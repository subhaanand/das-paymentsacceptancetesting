﻿using System.Linq;
using SFA.DAS.Payments.AcceptanceTests.Refactoring.Contexts;
using SFA.DAS.Payments.AcceptanceTests.Refactoring.ReferenceDataModels;

namespace SFA.DAS.Payments.AcceptanceTests.Refactoring.Assertions.PaymentsAndEarningsRules
{
    public class SfaLevyAdditionalPaymentsRule : PaymentsRuleBase
    {
        public override void AssertBreakdown(EarningsAndPaymentsBreakdown breakdown, SubmissionContext submissionContext)
        {
            var payments = GetPaymentsForBreakdown(breakdown, submissionContext)
                .Where(p => p.FundingSource == FundingSource.FullyFundedSfa && p.ContractType == ContractType.ContractWithEmployer)
                .ToArray();
            foreach (var period in breakdown.SfaLevyAdditionalPayments)
            {
                AssertResultsForPeriod(period, payments);
            }
        }

        protected override string FormatAssertionFailureMessage(PeriodValue period, decimal actualPaymentInPeriod)
        {
            return $"Expected SFA Levy additional payment of {period.Value} in {period.PeriodName} but was actually {actualPaymentInPeriod}";
        }
    }
}