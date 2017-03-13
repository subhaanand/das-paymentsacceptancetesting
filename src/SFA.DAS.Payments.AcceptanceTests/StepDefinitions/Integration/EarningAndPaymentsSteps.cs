﻿using System;
using System.Linq;
using NUnit.Framework;
using ProviderPayments.TestStack.Core;
using SFA.DAS.Payments.AcceptanceTests.Contexts;
using SFA.DAS.Payments.AcceptanceTests.DataHelpers;
using SFA.DAS.Payments.AcceptanceTests.DataHelpers.Entities;
using SFA.DAS.Payments.AcceptanceTests.Enums;
using SFA.DAS.Payments.AcceptanceTests.ExecutionEnvironment;
using SFA.DAS.Payments.AcceptanceTests.StepDefinitions.Base;
using TechTalk.SpecFlow;
using SFA.DAS.Payments.AcceptanceTests.Entities;

namespace SFA.DAS.Payments.AcceptanceTests.StepDefinitions.Integration
{
    //[Binding]
    public class EarningAndPaymentsSteps : BaseStepDefinitions
    {
        public EarningAndPaymentsSteps(StepDefinitionsContext earningAndPaymentsContext)
            :base(earningAndPaymentsContext)
        {
        }

        [When(@"an ILR file is submitted with the following data:")]
        public void WhenAnIlrFileIsSubmittedWithTheFollowingData(Table table)
        {
            if (table.Header.Contains("home postcode deprivation"))
            {
                var disadvatnageUplift = table.Rows[0].Value<string>("home postcode deprivation");

                if (!string.IsNullOrEmpty(disadvatnageUplift))
                {
                    ReferenceDataHelper.SavePostCodeDisadvantageUplift(disadvatnageUplift, EnvironmentVariables);
                }
            }
            ProcessIlrFileSubmissions(table);
        }

        [When(@"an ILR file is submitted every month with the following data:")]
        public void WhenAnIlrFileIsSubmittedEveryMonthWithTheFollowingData(Table table)
        {
            ProcessIlrFileSubmissions(table);
        }

        [When(@"an ILR file is submitted for the first time on (.*) with the following data:")]
        public void WhenAnIlrFileIsSubmittedForTheFirstTimeInAMonthWithTheFollowingData(string date, Table table)
        {
            var submissionDate = DateTime.Parse(date).NextCensusDate();
           
            ProcessIlrFileSubmissions(table, submissionDate);
        }

        [When(@"the providers submit the following ILR files:")]
        public void WhenTheProvidersSubmitTheFollowingIlrFiles(Table table)
        {
             ProcessIlrFileSubmissions(table);
        }

        [When(@"an ILR file is submitted on (.*) with the following data:")]
        public void WhenAnIlrFileIsSubmittedOnADayWithTheFollowingData(string date, Table table)
        {
            ProcessIlrFileSubmissions(table);
        }

        [When(@"an ILR file is submitted on (.*) with the following data:"),Scope(Scenario = "Earnings and payments for a DAS learner, levy available, where a learner switches from DAS to Non Das employer at the end of month")]
        public void WhenAnIlrFileIsSubmittedOnADayWithTheFollowingDataNoSubmission(string date, Table table)
        {
            ScenarioContext.Current.Add("learners", table);
            
        }

        [When(@"an ILR file is submitted with the following data:"), 
            Scope(Scenario = "Apprentice changes from a non-DAS to DAS employer, levy is available for the DAS employer")]
        public void WhenAnIlrFileIsSubmittedWithTheFollowingDataNoSubmission(Table table)
        {
            ScenarioContext.Current.Add("learners", table);
        }

        [When(@"an ILR file is submitted with the following data:")]
        [Scope(Tag = "LearnerChangesEmployerGapInCommitments")]
        [Scope(Tag = "SmallEmployerNonDasMultipleEmploymentStatuses")]
        [Scope(Tag = "SmallEmployerMultipleEmploymentStatus")]

        [Scope(Tag = "LearningSupport")]
        public void WhenAnIlrFileIsSubmittedWithTheFollowingDataAndThereIsAnotherWhenStepInTheScenario(Table table)
        {
            ScenarioContext.Current.Add("learners", table);
        }

        [When(@"the Contract type in the ILR is:"), Scope(Tag = @"LearnerChangesEmployerGapInCommitments")]
        public void WhenTheContractTypeInTheIlrIsNoSubmission(Table table)
        {
            BuildContractTypes(table);
        }

        [When(@"the employment status in the ILR is:")]
        public void WhenTheEmploymentStatusInTheILRIs(Table table)
        {
             Table learnerTable = null;

            PopulateEmploymentStatuses(table);
            
            ScenarioContext.Current.TryGetValue("learners", out learnerTable);
            
            ProcessIlrFileSubmissions(learnerTable);
        }   


        [When(@"the Contract type in the ILR is:")]
        public void WhenTheContractTypeInTheIlrIs(Table table)
        {
            Table learnerTable = null ;

            BuildContractTypes(table);
            
            ScenarioContext.Current.TryGetValue("learners", out learnerTable);
            ProcessIlrFileSubmissions(learnerTable);
        }

        [When(@"the learning support status of the ILR is:")]
        public void WhenTheLearningSupportStatusOfTheIlrIs(Table table)
        {
            Table learnerTable = null;

            BuildLearningSupportRecords(table);

            ScenarioContext.Current.TryGetValue("learners", out learnerTable);
            ProcessIlrFileSubmissions(learnerTable);
        }

        [Then(@"the provider earnings and payments break down as follows:")]
        public void ThenTheProviderEarningsBreakDownAsFollows(Table table)
        {
            var provider = StepDefinitionsContext.Providers[0];

            VerifyProviderEarningsAndPayments(provider.Ukprn,null, table);
        }

        [Then(@"the earnings and payments break down for (.*) is as follows:")]
        public void ThenAProviderEarningsBreakDownAsFollows(string providerName, Table table)
        {
            var provider = StepDefinitionsContext.Providers.Single(p => p.Name == providerName);

            VerifyProviderEarningsAndPayments(provider.Ukprn,null, table);
        }

        [Then(@"the transaction types for the payments are:")]
        public void ThenTheTransactionsForThePaymentsAre(Table table)
        {
            var ukprn = StepDefinitionsContext.Providers[0].Ukprn;
            VerifyTransactionsForThePayments(table,ukprn);
        }

        [Then(@"the transaction types for the payments for (.*) are:")]
        public void ThenTheTransactionTypesForThePaymentsForProviderBAre(string providerName,Table table)
        {
            var provider = StepDefinitionsContext.Providers.Single(x=> x.Name.Equals(providerName,StringComparison.CurrentCultureIgnoreCase));
            VerifyTransactionsForThePayments(table, provider.Ukprn);
        }

        [Then(@"the following capping will apply to the price episodes:")]
        public void ThenTheFollowingCappingWillApplyToThePriceEpisodes(Table table)
        {
            for (var rowIndex = 0; rowIndex < table.RowCount; rowIndex++)
            {
                var provider = table.Rows[rowIndex].Contains("provider")
                    ? StepDefinitionsContext.GetProvider(table.Rows[rowIndex].Value<string>("provider"))
                    : StepDefinitionsContext.GetDefaultProvider();

                var priceEpisode = provider.GetPriceEpisode(table.Rows[rowIndex].Value<string>("price episode"));
                var expectedNegotiatedPrice = table.Rows[rowIndex].Value<decimal>("negotiated price");
                var expectedPreviousFunding = table.Rows[rowIndex].Value<decimal>("previous funding paid");
                var expectedPriceAboveCap = table.Rows[rowIndex].Value<decimal>("price above cap");
                var expectedPriceForSfaPayments = table.Rows[rowIndex].Value<decimal>("effective price for SFA payments");

                var actualPriceEpisode = LearnerDataHelper.GetOpaApprenticeshipPriceEpisode(provider.Ukprn, priceEpisode.Id, EnvironmentVariables);

                Assert.AreEqual(expectedNegotiatedPrice, actualPriceEpisode.PriceEpisodeTotalTNPPrice, $"Expecting a total negotiated price of {expectedNegotiatedPrice} for pride episode {priceEpisode.DataLockMatchKey} but found {actualPriceEpisode.PriceEpisodeTotalTNPPrice}.");
                Assert.AreEqual(expectedPreviousFunding, actualPriceEpisode.PriceEpisodePreviousEarnings, $"Expecting previous funding of {expectedPreviousFunding} for pride episode {priceEpisode.DataLockMatchKey} but found {actualPriceEpisode.PriceEpisodePreviousEarnings}.");
                Assert.AreEqual(expectedPriceAboveCap, actualPriceEpisode.PriceEpisodeUpperLimitAdjustment, $"Expecting a price above cap of {expectedPriceAboveCap} for pride episode {priceEpisode.DataLockMatchKey} but found {actualPriceEpisode.PriceEpisodeUpperLimitAdjustment}.");
                Assert.AreEqual(expectedPriceForSfaPayments, actualPriceEpisode.PriceEpisodeUpperBandLimit, $"Expecting an effective price for SFA payments of {expectedPriceForSfaPayments} for pride episode {priceEpisode.DataLockMatchKey} but found {actualPriceEpisode.PriceEpisodeUpperBandLimit}.");
            }
        }

        private void BuildContractTypes(Table table)
        {
            

            for (var rowIndex = 0; rowIndex < table.RowCount; rowIndex++)
            {
                var famCode = new LearningDeliveryFam
                {
                    FamCode = table.Rows[rowIndex]["contract type"] == "DAS" ? 1 : 2,
                    StartDate = DateTime.Parse(table.Rows[rowIndex]["date from"]),
                    EndDate = DateTime.Parse(table.Rows[rowIndex]["date to"]),
                    FamType = "ACT"
                };

                StepDefinitionsContext.ReferenceDataContext.AddLearningDeliveryFam(famCode);
            }
        }

        public void VerifyTransactionsForThePayments(Table table,long ukprn)
        {
            
            var onProgramRow = table.Rows.RowWithKey(RowKeys.OnProgramPayment);
            var completionRow = table.Rows.RowWithKey(RowKeys.CompletionPayment);
            var balancingRow = table.Rows.RowWithKey(RowKeys.BalancingPayment);
            var employerIncentiveRow = table.Rows.RowWithKey(RowKeys.DefaultEmployerIncentive);
            var providerIncentiveRow = table.Rows.RowWithKey(RowKeys.ProviderIncentive);

            var frameworkUpliftOnProgRow = table.Rows.RowWithKey(RowKeys.FrameworkUpliftOnProgramme);
            var frameworkUpliftBalancingRow = table.Rows.RowWithKey(RowKeys.FrameworkUpliftBalancing);
            var frameworkUpliftCompletionRow = table.Rows.RowWithKey(RowKeys.FrameworkUpliftCompletion);
            var disadvatngePaymentRow = table.Rows.RowWithKey(RowKeys.ProviderDisadvantageUplift);

            var englishAndMathsOnProgRow = table.Rows.RowWithKey(RowKeys.EnglishAndMathsOnProgramme);
            var englishAndMathsBalancingRow = table.Rows.RowWithKey(RowKeys.EnglishAndMathsBlancing);

            for (var colIndex = 1; colIndex < table.Header.Count; colIndex++)
            {
                var periodName = table.Header.ElementAt(colIndex);
                if (periodName == "...")
                {
                    continue;
                }

                var periodMonth = int.Parse(periodName.Substring(0, 2));
                var periodYear = int.Parse(periodName.Substring(3)) + 2000;
                var periodDate = new DateTime(periodYear, periodMonth, 1).NextCensusDate();

                VerifyPaymentsDueByTransactionType(ukprn, periodName, periodDate, colIndex, TransactionType.OnProgram, onProgramRow);
                VerifyPaymentsDueByTransactionType(ukprn, periodName, periodDate, colIndex, TransactionType.Completion, completionRow);
                VerifyPaymentsDueByTransactionType(ukprn, periodName, periodDate, colIndex, TransactionType.Balancing, balancingRow);

                VerifyEmployerPaymentsDueByTransactionType(ukprn, periodName, periodDate, colIndex,table);

                VerifyPaymentsDueByTransactionType(ukprn, periodName, 
                                                    periodDate, colIndex, 
                                                    new TransactionType[] {
                                                            TransactionType.First16To18ProviderIncentive,
                                                            TransactionType.Second16To18ProviderIncentive},
                                                    providerIncentiveRow,null,FundingSource.FullyFundedSfa);

                VerifyPaymentsDueByTransactionType(ukprn, periodName, periodDate, colIndex, new TransactionType[] { TransactionType.OnProgramme16To18FrameworkUplift }, frameworkUpliftOnProgRow,null,FundingSource.FullyFundedSfa);
                VerifyPaymentsDueByTransactionType(ukprn, periodName, periodDate, colIndex, new TransactionType[] { TransactionType.Completion16To18FrameworkUplift }, frameworkUpliftCompletionRow,null, FundingSource.FullyFundedSfa);
                VerifyPaymentsDueByTransactionType(ukprn, periodName, periodDate, colIndex, new TransactionType[] { TransactionType.Balancing16To18FrameworkUplift }, frameworkUpliftBalancingRow,null, FundingSource.FullyFundedSfa);

                VerifyPaymentsDueByTransactionType(ukprn, periodName, periodDate, colIndex, new TransactionType[] { TransactionType.OnProgrammeMathsAndEnglish }, englishAndMathsOnProgRow, null, FundingSource.FullyFundedSfa);
                VerifyPaymentsDueByTransactionType(ukprn, periodName, periodDate, colIndex, new TransactionType[] { TransactionType.BalancingMathsAndEnglish}, englishAndMathsBalancingRow, null, FundingSource.FullyFundedSfa);

                VerifyPaymentsDueByTransactionType(ukprn, periodName,
                                                               periodDate, colIndex,
                                                               new TransactionType[] {
                                                            TransactionType.FirstDisadvantagePayment,
                                                            TransactionType.SecondDisadvantagePayment},
                                                               disadvatngePaymentRow, null, FundingSource.FullyFundedSfa);

            }
        }

        [Then(@"the provider earnings and payments break down for ULN (.*) as follows:")]
        public void ThenTheProviderEarningsAndPaymentsBreakDownForAUlnAsFollows(long uln, Table table)
        {
            var provider = StepDefinitionsContext.Providers.Single();

            Assert.IsTrue(provider.EarnedByPeriodByUln.ContainsKey(uln));

            VerifyProviderEarningsAndPayments(provider.Ukprn,uln, table);
        }


        private void ProcessIlrFileSubmissions(Table table, DateTime? firstSubmissionDate = null)
        {
            SetupContextProviders(table);
            SetupContexLearners(table);

            AddScenarioReferenceData();

            var startDate = firstSubmissionDate ?? StepDefinitionsContext.GetIlrStartDate().NextCensusDate();

            if (firstSubmissionDate != null)
                ScenarioContext.Current.Add("firstSubmissionDate", firstSubmissionDate);

            ProcessMonths(startDate);
        }

        private void ProcessMonths(DateTime start)
        {
            var processService = new ProcessService(new TestLogger());

            var periodId = 1;
            var date = start.NextCensusDate();
            var endDate = StepDefinitionsContext.GetIlrEndDate();
            var lastCensusDate = endDate.NextCensusDate();

            while (date <= lastCensusDate)
            {
                var period = date.GetPeriod();

                SetupPeriodReferenceData(date);

                UpdateAccountsBalances(period);

                var academicYear = date.GetAcademicYear();

                SetupEnvironmentVariablesForMonth(date, academicYear, ref periodId);

                foreach (var provider in StepDefinitionsContext.Providers)
                {
                    SubmitIlr(provider,
                                academicYear,
                                date,
                                processService);
                    
                }

                SubmitMonthEnd(date, processService);

                date = date.AddDays(15).NextCensusDate();
            }
        }
       
        private void VerifyProviderEarningsAndPayments(long ukprn, long? uln, Table table)
        {
            var earnedRow = table.Rows.RowWithKey(RowKeys.Earnings);
            var govtCofundLevyContractRow = table.Rows.RowWithKey(RowKeys.CoFinanceGovernmentPaymentForLevyContracts);
            var govtCofundNonLevyContractRow = table.Rows.RowWithKey(RowKeys.CoFinanceGovernmentPaymentForNonLevyContracts);

            var govtAdditionalPaymentsRow = StepDefinitionsContext.DasScenario ? 
                                            table.Rows.RowWithKey(RowKeys.SfaLevyAdditionalPaymentsBudget) :
                                            table.Rows.RowWithKey(RowKeys.SfaNonLevyAdditionalPaymentsBudget);
            
            for (var colIndex = 1; colIndex < table.Header.Count; colIndex++)
            {
                var periodName = table.Header.ElementAt(colIndex);
                if (periodName == "...")
                {
                    continue;
                }

                var periodMonth = int.Parse(periodName.Substring(0, 2));
                var periodYear = int.Parse(periodName.Substring(3)) + 2000;
                var periodDate = new DateTime(periodYear, periodMonth, 1).NextCensusDate();


                VerifyEarningsForPeriod(ukprn,uln, periodName, colIndex, earnedRow);
                VerifyGovtCofinanceLevyContractPayments(ukprn,uln, periodName, periodDate, colIndex, govtCofundLevyContractRow);
                VerifyGovtCofinanceNonLevyContractPayments(ukprn, uln, periodName, periodDate, colIndex, govtCofundNonLevyContractRow);
                VerifyAdditionalGovtFundedEarnings(ukprn, uln, periodName, periodDate, colIndex, govtAdditionalPaymentsRow);

                if (StepDefinitionsContext.DasScenario)
                {
                    foreach (var employer in StepDefinitionsContext.ReferenceDataContext.Employers)
                    {
                        var levyPaidRow = table.Rows.RowWithKey(RowKeys.DefaultLevyPayment)
                                          ?? table.Rows.RowWithKey($"{employer.Name}{RowKeys.LevyPayment}");

                        var employerCofundRow = table.Rows.RowWithKey(RowKeys.DefaultCoFinanceEmployerPayment)
                                                ?? table.Rows.RowWithKey($"{RowKeys.CoFinanceEmployerPayment}{employer.Name}");

                        VerifyLevyPayments(ukprn, uln, periodName, periodDate, employer.AccountId, colIndex, levyPaidRow);
                        VerifyEmployerCofinancePayments(ukprn, uln, periodName, periodDate, employer.AccountId, colIndex, employerCofundRow, employer.LearnersType);
                    }
                }
                else
                {
                    var employerCofundRow = table.Rows.RowWithKey(RowKeys.DefaultCoFinanceEmployerPayment);

                    VerifyEmployerCofinancePayments(ukprn, uln, periodName, periodDate, 0, colIndex, employerCofundRow, LearnerType.ProgrammeOnlyNonDas);
                }
            }
        }

        private void VerifyEarningsForPeriod(long ukprn, long? uln , string periodName, int colIndex, TableRow earnedRow)
        {
            if (earnedRow == null)
            {
                return;
            }

            var earnedByPeriod = StepDefinitionsContext.GetProviderEarnedByPeriod(ukprn,uln);

            if (!earnedByPeriod.ContainsKey(periodName))
            {
                Assert.Fail($"Expected value for period {periodName} but none found");
            }

            var expectedEarning = decimal.Parse(earnedRow[colIndex]);
            Assert.IsTrue(earnedByPeriod.ContainsKey(periodName), $"Expected earning for period {periodName} but none found");
            Assert.AreEqual(expectedEarning, Math.Round(earnedByPeriod[periodName],2), $"Expected earning of {expectedEarning} for period {periodName} but found {earnedByPeriod[periodName]}");
        }
        private void VerifyLevyPayments(long ukprn,
                                        long? uln, 
                                        string periodName, 
                                        DateTime periodDate, 
                                        long accountId,
                                        int colIndex, 
                                        TableRow levyPaidRow)
        {
            if (levyPaidRow == null)
            {
                return;
            }

            var levyPaymentDate = periodDate.AddMonths(-1);

            var levyPayments = PaymentsDataHelper.GetAccountPaymentsForPeriod(
                                                    ukprn,
                                                    accountId,
                                                    uln,
                                                    levyPaymentDate.Year,
                                                    levyPaymentDate.Month,
                                                    FundingSource.Levy,
                                                    ContractType.ContractWithEmployer,
                                                    EnvironmentVariables)
                               ?? new PaymentEntity[0];

            var actualLevyPayment = levyPayments.Length == 0 ? 0m : levyPayments.Sum(p => p.Amount);
            var expectedLevyPayment = decimal.Parse(levyPaidRow[colIndex]);
            Assert.AreEqual(expectedLevyPayment, Math.Round(actualLevyPayment,2), $"Expected a levy payment of {expectedLevyPayment} but made a payment of {actualLevyPayment} for {periodName}");
        }
        private void VerifyGovtCofinanceLevyContractPayments(long ukprn, 
                                                long? uln,
                                                string periodName, 
                                                DateTime periodDate,
                                                int colIndex,
                                                TableRow govtCofundRow)
        {
            if (govtCofundRow == null)
            {
                return;
            }

            var cofinancePayments = PaymentsDataHelper.GetPaymentsForPeriod(
                                                        ukprn,
                                                        uln,
                                                        periodDate.Year,
                                                        periodDate.Month,
                                                        FundingSource.CoInvestedSfa,
                                                        ContractType.ContractWithEmployer,
                                                        EnvironmentVariables)
                                    ?? new PaymentEntity[0];

            var actualGovtPayment = cofinancePayments.Sum(p => p.Amount);
            var expectedGovtPayment = decimal.Parse(govtCofundRow[colIndex]);
            Assert.AreEqual(expectedGovtPayment, actualGovtPayment, $"Expected a levy contract government co-finance payment of {expectedGovtPayment} but made a payment of {actualGovtPayment} for {periodName}");
        }
        private void VerifyGovtCofinanceNonLevyContractPayments(long ukprn,
                                                long? uln,
                                                string periodName,
                                                DateTime periodDate,
                                                int colIndex,
                                                TableRow govtCofundRow)
        {
            if (govtCofundRow == null)
            {
                return;
            }

            var cofinancePayments = PaymentsDataHelper.GetPaymentsForPeriod(
                                                        ukprn,
                                                        uln,
                                                        periodDate.Year,
                                                        periodDate.Month,
                                                        FundingSource.CoInvestedSfa,
                                                        ContractType.ContractWithSfa,
                                                        EnvironmentVariables)
                                    ?? new PaymentEntity[0];

            var actualGovtPayment = cofinancePayments.Sum(p => p.Amount);
            var expectedGovtPayment = decimal.Parse(govtCofundRow[colIndex]);
            Assert.AreEqual(expectedGovtPayment, Math.Round(actualGovtPayment,2), $"Expected a government co-finance payment of {expectedGovtPayment} but made a payment of {actualGovtPayment} for {periodName}");
        }
        private void VerifyEmployerCofinancePayments(long ukprn,long? uln, string periodName, DateTime periodDate, long accountId,
            int colIndex, TableRow employerCofundRow, LearnerType learnersType)
        {
            if (employerCofundRow == null)
            {
                return;
            }

            var employerPaymentDate = periodDate.AddMonths(-1);

            var cofinancePayments = PaymentsDataHelper.GetAccountPaymentsForPeriod(
                                                        ukprn,
                                                        learnersType == LearnerType.ProgrammeOnlyNonDas ?  (long?)null : accountId ,
                                                        uln,
                                                        employerPaymentDate.Year,
                                                        employerPaymentDate.Month,
                                                        FundingSource.CoInvestedEmployer,
                                                         learnersType == LearnerType.ProgrammeOnlyNonDas ? ContractType.ContractWithSfa : ContractType.ContractWithEmployer,
                                                        EnvironmentVariables)
                                    ?? new PaymentEntity[0];

            var actualEmployerPayment = cofinancePayments.Sum(p => p.Amount);
            var expectedEmployerPayment = decimal.Parse(employerCofundRow[colIndex]);
            Assert.AreEqual(expectedEmployerPayment, Math.Round(actualEmployerPayment,2), $"Expected a employer co-finance payment of {expectedEmployerPayment} but made a payment of {actualEmployerPayment} for {periodName}");
        }
        private void VerifyPaymentsDueByTransactionType(long ukprn, 
                                                        string periodName, 
                                                        DateTime periodDate, 
                                                        int colIndex, 
                                                        TransactionType paymentType, 
                                                        TableRow paymentsRow)
        {
            VerifyPaymentsDueByTransactionType(ukprn, periodName, periodDate, colIndex, 
                                        new TransactionType[] { paymentType }, paymentsRow,null, 
                                        StepDefinitionsContext.DasScenario
                                        ? (FundingSource?)null
                                        : FundingSource.CoInvestedSfa);
        }

        private void VerifyEmployerPaymentsDueByTransactionType(long ukprn,
                                                       string periodName,
                                                       DateTime periodDate,
                                                       int colIndex,
                                                       Table table)
        {

            if (StepDefinitionsContext.DasScenario)
            {
                foreach (var employer in StepDefinitionsContext.ReferenceDataContext.Employers)
                {
                    long? accountId = null;
                    TableRow employerIncentiveRow = table.Rows.RowWithKey(string.Format(RowKeys.DefaultEmployerIncentive, string.Empty)); 
                    if (table.Rows.RowWithKey(string.Format(RowKeys.DefaultEmployerIncentive, string.Empty)) == null)
                    {
                        accountId = employer.AccountId;
                        employerIncentiveRow = table.Rows.RowWithKey(string.Format(RowKeys.DefaultEmployerIncentive, employer.Name));
                    }

                    VerifyPaymentsDueByTransactionType(ukprn, periodName, periodDate, colIndex, new TransactionType[] {
                                                            TransactionType.First16To18EmployerIncentive,
                                                            TransactionType.Second16To18EmployerIncentive  }, 
                                                            employerIncentiveRow,
                                                            accountId,FundingSource.FullyFundedSfa);
                   
                }
            }
        }

        private void VerifyPaymentsDueByTransactionType(long ukprn, 
                                                        string periodName, 
                                                        DateTime periodDate, 
                                                        int colIndex, 
                                                        TransactionType[] paymentTypes,
                                                        TableRow paymentsRow,
                                                        long? accountId = null,
                                                        FundingSource? fundingSource = null)
        {

            if (paymentsRow == null)
            {
                return;
            }

            var paymentTypesFilter = Array.ConvertAll(paymentTypes, value => (int)value);
            
            var paymentsDueDate = periodDate.AddMonths(-1);

            var paymentsDue = PaymentsDataHelper.GetAccountPaymentsForPeriod(
                ukprn,
                accountId,
                null,
                paymentsDueDate.Year,
                paymentsDueDate.Month,
                fundingSource,
                StepDefinitionsContext.DasScenario
                    ? ContractType.ContractWithEmployer
                    : ContractType.ContractWithSfa,
                EnvironmentVariables);

            var actualPaymentDue = paymentsDue.Length == 0 ? 0m : paymentsDue.Where(p => paymentTypesFilter.Contains(p.TransactionType)).Sum(p => p.Amount);
            var expectedPaymentDue = decimal.Parse(paymentsRow[colIndex]);
            
            Assert.AreEqual(expectedPaymentDue, actualPaymentDue, $"Expected {string.Join(" and ",paymentTypes)} payment due of {expectedPaymentDue} but made a payment of {actualPaymentDue} for {periodName}");
        }

        private void VerifyAdditionalGovtFundedEarnings(long ukprn,
                                      long? uln,
                                      string periodName,
                                      DateTime periodDate,
                                      int colIndex,
                                      TableRow additionalEarningsRow)
        {
            if (additionalEarningsRow == null)
            {
                return;
            }

            var additionalEarnings = PaymentsDataHelper.GetPaymentsForPeriod(
                                                       ukprn,
                                                       uln,
                                                       periodDate.Year,
                                                       periodDate.Month,
                                                       FundingSource.FullyFundedSfa,
                                                       StepDefinitionsContext.DasScenario ? 
                                                        ContractType.ContractWithEmployer : 
                                                        ContractType.ContractWithSfa,
                                                       EnvironmentVariables)
                                   ?? new PaymentEntity[0];

            var actualEarningsDue = additionalEarnings.Length == 0 ? 0m : additionalEarnings.Sum(p => p.Amount);

            var expectedPaymentDue = decimal.Parse(additionalEarningsRow[colIndex]);
            Assert.AreEqual(expectedPaymentDue, actualEarningsDue, $"Expected additional earnings of {expectedPaymentDue} but earned a payment of {actualEarningsDue} for {periodName}");

        }

        private void BuildLearningSupportRecords(Table table)
        {
            for (var rowIndex = 0; rowIndex < table.RowCount; rowIndex++)
            {
                var famCode = new LearningDeliveryFam
                {
                    FamCode = table.Rows[rowIndex].Value<int>("Learning support code"),
                    StartDate = DateTime.Parse(table.Rows[rowIndex].Value<string>("date from")),
                    EndDate = DateTime.Parse(table.Rows[rowIndex].Value<string>("date to")),
                    FamType = "LSF"
                };

                StepDefinitionsContext.ReferenceDataContext.AddLearningDeliveryFam(famCode);
            }
        }
    }
}
