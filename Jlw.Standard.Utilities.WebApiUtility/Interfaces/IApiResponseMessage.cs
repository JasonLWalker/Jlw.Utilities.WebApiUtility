using Newtonsoft.Json;

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
        [JsonProperty]
        string Message { get; }

        /// <summary>
        /// The type of Api response message that is being returned. This can also be used to determine how the message should be displayed to the user.
        /// </summary>
        [JsonProperty]
        [JsonConverter(typeof(JsonConverter<int>))]
        ApiMessageType MessageType { get; }
    }
}