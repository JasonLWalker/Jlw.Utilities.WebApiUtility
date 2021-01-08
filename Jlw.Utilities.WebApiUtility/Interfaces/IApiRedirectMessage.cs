using Jlw.Utilities.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace Jlw.Utilities.WebApiUtility
{
    /// <summary>
    /// A message that indicates that the user should be redirected to another location
    /// </summary>
    public interface IApiRedirectMessage : IApiResponseMessage
    {
        /// <summary>
        /// The URL to redirect the user to.
        /// </summary>
        [JsonProperty("RedirectUrl", NamingStrategyType = typeof(DefaultNamingStrategy), ItemConverterType = typeof(JlwJsonConverter<string>))]
        string RedirectUrl { get; }
    }
}