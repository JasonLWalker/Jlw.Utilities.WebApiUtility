using System;
using Newtonsoft.Json;

namespace Jlw.Standard.Utilities.WebApiUtility
{
    /// <summary>
    /// Class to wrap exceptions and return them as SPS WebApi messages
    /// </summary>
    public class ApiExceptionMessage : ApiRedirectMessage
    {
        /// <summary>
        /// Will always return a message of type "Danger"
        /// </summary>
        public new ApiMessageType MessageType => ApiMessageType.Danger;

        /// <summary>
        /// The message from the inner wrapped exception
        /// </summary>
        public string ExceptionMessage { get; internal set; }

        /// <summary>
        /// Type of exception that has occurred.
        /// </summary>
        public string ExceptionType { get; internal set; }


        /// <summary>
        /// Base constructor with no arguments
        /// </summary>
        public ApiExceptionMessage() : base("", "", ApiMessageType.Danger, "")
        {
            ExceptionMessage = "";
            ExceptionType = this.GetType().ToString();
            RedirectUrl = "";
        }

        /// <summary>
        /// Create an exception message
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="exmsg"></param>
        /// <param name="extype"></param>
        /// <param name="redirectUrl"></param>
        public ApiExceptionMessage(string msg, string exmsg = "", string extype = "", string redirectUrl = "") : base(msg)
        {
            ExceptionMessage = exmsg;
            ExceptionType = extype;
            RedirectUrl = redirectUrl;
        }

        /// <summary>
        /// Wrap an inner exception
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="ex"></param>
        /// <param name="redirectUrl"></param>
        public ApiExceptionMessage(string msg, Exception ex, string redirectUrl = "") : base(msg)
        {
            ExceptionMessage = ex.Message;
            ExceptionType = ex.GetType().ToString();
            RedirectUrl = redirectUrl;
        }

        public ApiExceptionMessage(string msg, string title = "", ApiMessageType messageType = ApiMessageType.Info, string redirectUrl = "") : base(msg, title, messageType, redirectUrl)
        {
        }
    }
}