// --------------------------------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by the SQL PLUS Code Generation Utility.
//     Changes to this file may cause incorrect behavior and will be lost if the code is regenerated.
//     Underlying Routine: CustomerDelete
//     Last Modified On: 3/15/2023 7:57:17 PM
//     Written By: Alan@sqlplus.net
//     Visit https://www.SQLPLUS.net for more information about the SQL PLUS build time ORM.
// </auto-generated>
// --------------------------------------------------------------------------------------------------------
namespace GettingStarted.DataServices.Best
{
    #nullable enable

    #region Using Statments

    using GettingStarted.DataServices.Best.Models;
    using System;
    using System.Data;
    using System.Data.SqlClient;
    using System.Threading;

    #endregion Using Statements

    /// <summary>
    /// This file contains the source code for the CustomerDelete routine.
    /// </summary>
    public partial class Service
    {
        #region Build SqlCommand

        private SqlCommand CustomerDelete_BuildCommand(SqlConnection cnn, CustomerDeleteInput input)
        {
            SqlCommand result = new SqlCommand()
            {
                CommandType = CommandType.StoredProcedure,
                CommandText = "[best].[CustomerDelete]",
                Connection = cnn
            };

            result.Parameters.Add(new SqlParameter()
            {
                ParameterName = "@ReturnValue",
                Direction = ParameterDirection.ReturnValue,
                SqlDbType = SqlDbType.Int,
                Scale = 0,
                Precision = 10,
                Value = DBNull.Value
            });

            result.Parameters.Add(new SqlParameter()
            {
                ParameterName = "@CustomerId",
                Direction = ParameterDirection.Input,
                SqlDbType = SqlDbType.Int,
                Scale = 0,
                Precision = 10,
                Value = input.CustomerId
            });

            return result;
        }

        #endregion Build SqlCommand

        #region Read Output Parameters And Return Value

        private void CustomerDelete_SetParameters(SqlCommand cmd, CustomerDeleteOutput output)
        {
            if(cmd.Parameters[0].Value != DBNull.Value)
            {
                output.ReturnValue = (CustomerDeleteOutput.Returns)cmd.Parameters[0].Value;
            }
        }

        #endregion Read Output Parameters And Return Value

        #region Execute Command

        private void CustomerDelete_Execute(SqlCommand cmd, CustomerDeleteOutput output)
        {
            cmd.ExecuteNonQuery();

            CustomerDelete_SetParameters(cmd, output);
        }

        #endregion Execute Command

        #region Public Service

        /// <summary>
        /// Deletes customer for the given CustomerId, parameter validation, return values.<br/>
        /// DB Routine: best.CustomerDelete<br/>
        /// Author: Alan@sqlplus.net<br/>
        /// </summary>
        /// <param name="input">CustomerDeleteInput instance.</param>
        /// <returns>Instance of CustomerDeleteOutput</returns>
        public CustomerDeleteOutput CustomerDelete(CustomerDeleteInput input)
        {
            ValidateInput(input, nameof(CustomerDelete));
            CustomerDeleteOutput output = new CustomerDeleteOutput();
			if(sqlConnection != null)
            {
                using (SqlCommand cmd = CustomerDelete_BuildCommand(sqlConnection, input))
                {
                    cmd.Transaction = sqlTransaction;
                    CustomerDelete_Execute(cmd, output);
                }
                return output;
            }
            for(int idx=0; idx <= retryOptions.RetryIntervals.Count; idx++)
            {
                if (idx > 0)
                {
                    Thread.Sleep(retryOptions.RetryIntervals[idx - 1]);
                }
                try
                {
                    using (SqlConnection cnn = new SqlConnection(connectionString))
                    using (SqlCommand cmd = CustomerDelete_BuildCommand(cnn, input))
                    {
                        cnn.Open();
						CustomerDelete_Execute(cmd, output);
                        cnn.Close();
                    }
					break;
                }
                catch(SqlException sqlException)
                {
                    AllowRetryOrThrowError(idx, sqlException);
                }
            }
            return output;
        }

        #endregion

    }
}

