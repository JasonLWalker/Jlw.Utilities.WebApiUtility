
using System.ComponentModel;
using System.Runtime.Serialization;
using Jlw.Utilities.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace Jlw.Standard.Utilities.WebApiUtility
{
    /// <summary>
    /// Enumeration of Message types. With the exception of the Redirect, these correspond to the Bootstrap 3 and Toastr message class types.
    /// </summary>
    [JsonConverter(typeof(JlwJsonConverter<int>))]
    public enum ApiMessageType
    {
        Success=0,
        Warning=1,
        Info=2,
        Danger=3,
        Alert=4,
        Redirect=5
    }
}