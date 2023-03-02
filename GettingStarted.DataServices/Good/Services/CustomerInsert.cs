// --------------------------------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by the SQL PLUS Code Generation Utility.
//     Changes to this file may cause incorrect behavior and will be lost if the code is regenerated.
//     Underlying Routine: CustomerInsert
//     Last Modified On: 3/1/2023 11:11:53 PM
//     Written By: Alan@SQLPlus.net
//     Visit https://www.SQLPLUS.net for more information about the SQL PLUS build time ORM.
// </auto-generated>
// --------------------------------------------------------------------------------------------------------
namespace GettingStarted.DataServices.Good
{
    #nullable enable

    #region Using Statments

    using GettingStarted.DataServices.Good.Models;
    using System;
    using System.Data;
    using System.Data.SqlClient;
    using System.Threading;

    #endregion Using Statements

    /// <summary>
    /// This file contains the source code for the CustomerInsert routine.
    /// </summary>
    public partial class Service
    {
        #region Build SqlCommand

        private SqlCommand CustomerInsert_BuildCommand(SqlConnection cnn, CustomerInsertInput input)
        {
            SqlCommand result = new SqlCommand()
            {
                CommandType = CommandType.StoredProcedure,
                CommandText = "[good].[CustomerInsert]",
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
                Direction = ParameterDirection.Output,
                SqlDbType = SqlDbType.Int,
                Scale = 0,
                Precision = 10,
                Value = DBNull.Value
            });

            result.Parameters.Add(new SqlParameter()
            {
                ParameterName = "@FirstName",
                Direction = ParameterDirection.Input,
                SqlDbType = SqlDbType.VarChar,
                Size = 64,
                Value = DBNull.Value
            });

            result.Parameters.Add(new SqlParameter()
            {
                ParameterName = "@LastName",
                Direction = ParameterDirection.Input,
                SqlDbType = SqlDbType.VarChar,
                Size = 64,
                Value = DBNull.Value
            });

            result.Parameters.Add(new SqlParameter()
            {
                ParameterName = "@Email",
                Direction = ParameterDirection.Input,
                SqlDbType = SqlDbType.VarChar,
                Size = 64,
                Value = DBNull.Value
            });

            if (input.FirstName != null)
            {
                result.Parameters["@FirstName"].Value = input.FirstName;
            }
            if (input.LastName != null)
            {
                result.Parameters["@LastName"].Value = input.LastName;
            }
            if (input.Email != null)
            {
                result.Parameters["@Email"].Value = input.Email;
            }
            return result;
        }

        #endregion Build SqlCommand

        #region Read Output Parameters And Return Value

        private void CustomerInsert_SetParameters(SqlCommand cmd, CustomerInsertOutput output)
        {
            if(cmd.Parameters[0].Value != DBNull.Value)
            {
                output.ReturnValue = (int?)cmd.Parameters[0].Value;
            }
            if(cmd.Parameters[1].Value != DBNull.Value)
            {
                output.CustomerId = (int?)cmd.Parameters[1].Value;
            }
        }

        #endregion Read Output Parameters And Return Value

        #region Execute Command

        private void CustomerInsert_Execute(SqlCommand cmd, CustomerInsertOutput output)
        {
            cmd.ExecuteNonQuery();

            CustomerInsert_SetParameters(cmd, output);
        }

        #endregion Execute Command

        #region Public Service

        /// <summary>
        /// Inserts a new customer.<br/>
        /// DB Routine: good.CustomerInsert<br/>
        /// Author: Alan@SQLPlus.net<br/>
        /// </summary>
        /// <param name="input">CustomerInsertInput instance.</param>
        /// <returns>Instance of CustomerInsertOutput</returns>
        public CustomerInsertOutput CustomerInsert(CustomerInsertInput input)
        {
            ValidateInput(input, nameof(CustomerInsert));
            CustomerInsertOutput output = new CustomerInsertOutput();
			if(sqlConnection != null)
            {
                using (SqlCommand cmd = CustomerInsert_BuildCommand(sqlConnection, input))
                {
                    cmd.Transaction = sqlTransaction;
                    CustomerInsert_Execute(cmd, output);
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
                    using (SqlCommand cmd = CustomerInsert_BuildCommand(cnn, input))
                    {
                        cnn.Open();
						CustomerInsert_Execute(cmd, output);
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

