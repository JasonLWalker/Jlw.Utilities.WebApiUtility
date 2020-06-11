using Newtonsoft.Json;

namespace Jlw.Standard.Utilities.WebApiUtility
{
    /// <summary>
    /// A message that indicates that the user should be redirected to another location
    /// </summary>
    public interface IApiRedirectMessage : IApiResponseMessage
    {
        /// <summary>
        /// The URL to redirect the user to.
        /// </summary>
        [JsonProperty]
        string RedirectUrl { get; }
    }
}