﻿using System;
using System.Data.SqlClient;
using Dapper;
using ProviderPayments.TestStack.Core;

namespace SFA.DAS.Payments.AcceptanceTests.DataHelpers
{
    internal static class CommitmentDataHelper
    {
        internal static void CreateCommitment(long commitmentId, long ukprn, long uln, string accountId,
            DateTime startDate, DateTime endDate, decimal agreedCost, long standardCode,
            int frameworkCode, int programmeType, int pathwayCode, int priority, string versionId, EnvironmentVariables environmentVariables)
        {

            using (var connection = new SqlConnection(environmentVariables.DedsDatabaseConnectionString))
            {
                connection.Execute("INSERT INTO DasCommitments " +
                                   "(CommitmentId, Ukprn, Uln, AccountId, StartDate, EndDate, AgreedCost, StandardCode, FrameworkCode, ProgrammeType, PathwayCode, Priority, VersionId) " +
                                   "VALUES " +
                                   "(@commitmentId, @ukprn, @uln, @accountId, @startDate, @endDate, @agreedCost, @standardCode, @frameworkCode, @programmeType, @pathwayCode, @priority, @versionId)",
                    new { commitmentId, ukprn, uln, accountId, startDate, endDate, agreedCost, standardCode, frameworkCode, programmeType, pathwayCode, priority, versionId });
            }
        }
    }
}