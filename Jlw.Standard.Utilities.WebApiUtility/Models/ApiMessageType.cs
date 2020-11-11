
using System.Runtime.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace Jlw.Standard.Utilities.WebApiUtility
{
    /// <summary>
    /// Enumeration of Message types. With the exception of the Redirect, these correspond to the Bootstrap 3 and Toastr message class types.
    /// </summary>
    [DataContract]
    [JsonConverter(typeof(StringEnumConverter))]
    public enum ApiMessageType
    {
        [EnumMember(Value = "0")]
        Success,
        [EnumMember(Value = "1")]
        Warning,
        [EnumMember(Value = "2")]
        Info,
        [EnumMember(Value = "3")]
        Danger,
        [EnumMember(Value = "4")]
        Alert,
        [EnumMember(Value = "5")]
        Redirect
    }
}