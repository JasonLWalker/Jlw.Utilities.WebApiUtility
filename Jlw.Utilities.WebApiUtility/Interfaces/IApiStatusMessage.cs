using Jlw.Utilities.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace Jlw.Utilities.WebApiUtility
{
    /// <summary>
    /// Status type SPS WebApi response message. These messages will commonly be displayed in toasts or popup dialog boxes.
    /// </summary>
    public interface IApiStatusMessage : IApiResponseMessage
    {
        /// <summary>
        /// Dialog or Toast title line.
        /// </summary>
        [JsonProperty("Title", NamingStrategyType = typeof(DefaultNamingStrategy), ItemConverterType = typeof(JlwJsonConverter<string>))]
        string Title { get; }

    }
}