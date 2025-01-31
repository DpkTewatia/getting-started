// --------------------------------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by the SQL PLUS Code Generation Utility.
//     Changes to this file may cause incorrect behavior and will be lost if the code is regenerated.
//     Underlying Routine: CustomerDelete
//     Last Modified On: 3/27/2023 10:16:34 PM
//     Written By: alan@sqlplus.net
//     Visit https://www.SQLPLUS.net for more information about the SQL PLUS build time ORM.
// </auto-generated>
// --------------------------------------------------------------------------------------------------------
namespace GettingStarted.DataServices.Default.Models
{
    #nullable enable

    #region usings

    using SqlPlusBase;
    using System.ComponentModel.DataAnnotations;

    #endregion usings

    /// <summary>
    /// Input object for the CustomerDelete service.
    /// </summary>
    public partial class CustomerDeleteInput : ValidInput
    {
        #region Constructors

        /// <summary>
        /// Empty constructor for CustomerDeleteInput.
        /// </summary>
        public CustomerDeleteInput() { }

        /// <summary>
        /// Parameterized constructor for CustomerDeleteInput.
        /// </summary>
        /// <param name="CustomerId">The customer id for the record to delete.</param>
        public CustomerDeleteInput(int? CustomerId)
        {
            this.CustomerId = CustomerId;
        }

        #endregion Constructors

        #region Fields

        private int? _CustomerId;
        /// <summary>
        /// The customer id for the record to delete.
        /// </summary>
        [Required]
        public int? CustomerId
        {
            get => _CustomerId;
            set => _CustomerId = value;
        }

        #endregion

    }
}