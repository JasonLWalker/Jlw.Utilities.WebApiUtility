using Newtonsoft.Json;

namespace Jlw.Standard.Utilities.WebApiUtility
{
    /// <summary>
    /// Status type SPS WebApi response message. These messages will commonly be displayed in toasts or popup dialog boxes.
    /// </summary>
    public interface IApiStatusMessage : IApiResponseMessage
    {
        /// <summary>
        /// Dialog or Toast title line.
        /// </summary>
        [JsonProperty]
        string Title { get; }

    }
}