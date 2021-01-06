using Newtonsoft.Json;

namespace Jlw.Standard.Utilities.WebApiUtility
{
    /// <summary>
    /// A message that indicates that the user should be redirected to another location
    /// </summary>
    public class ApiRedirectMessage : ApiStatusMessage, IApiRedirectMessage
    {
        /// <summary>
        /// URL address that the user should be redirected to.
        /// </summary>
        public string RedirectUrl { get; internal set; }

        /// <summary>
        /// Public constructor
        /// </summary>
        /// <param name="msg">Message string to be displayed to user</param>
        /// <param name="title">Message Title</param>
        /// <param name="messageType">The type of Api response message that is being returned.</param>
        /// <param name="redirectUrl">URL address that the user should be redirected to.</param>
        public ApiRedirectMessage(string msg, string title = "", ApiMessageType messageType=ApiMessageType.Info, string redirectUrl = "" ) : base (msg, title, messageType)
        {
            RedirectUrl = redirectUrl;
        }
    }
}