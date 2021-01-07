using Jlw.Utilities.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Serialization;

namespace Jlw.Standard.Utilities.WebApiUtility
{
    /// <summary>
    /// Base Interface for a SPS WebApi response message
    /// </summary>
    public interface IApiResponseMessage
    {
        /// <summary>
        /// Message string to be displayed to user
        /// </summary>
        [JsonProperty("Message", NamingStrategyType = typeof(DefaultNamingStrategy), ItemConverterType = typeof(JlwJsonConverter<string>))]
        string Message { get; }

        /// <summary>
        /// The type of Api response message that is being returned. This can also be used to determine how the message should be displayed to the user.
        /// </summary>
        [JsonProperty("MessageType", NamingStrategyType = typeof(DefaultNamingStrategy))]
        [Newtonsoft.Json.JsonConverter(typeof(JlwJsonAsStringConverter<int>))]
        ApiMessageType MessageType { get; }
    }
}