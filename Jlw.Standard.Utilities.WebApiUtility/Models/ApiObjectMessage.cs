using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Jlw.Standard.Utilities.WebApiUtility
{
    /// <summary>
    /// Status type SPS WebApi response message. These messages will commonly be displayed in toasts or popup dialog boxes.
    /// </summary>
    public class ApiObjectMessage : JObject, IApiStatusMessage
    {
        /// <summary>
        /// Message string to be displayed to user
        /// </summary>
        [JsonProperty]
        public string Message { get; internal set; }

        /// <summary>
        /// The type of Api response message that is being returned. This can also be used to determine how the message should be displayed to the user.
        /// </summary>
        [JsonProperty]
        public ApiMessageType MessageType { get; internal set; }

        /// <summary>
        /// Dialog or Toast title line.
        /// </summary>
        [JsonProperty]
        public string Title { get; internal set; }

        /// <summary>
        /// Public constructor
        /// </summary>
        /// <param name="msg">Message string to be displayed to user</param>
        /// <param name="title">Message Title</param>
        /// <param name="messageType">The type of Api response message that is being returned.</param>
        public ApiObjectMessage(object oOrig, string msg, string title = "", ApiMessageType messageType=ApiMessageType.Info)
        {
            Merge(JObject.FromObject(oOrig), new JsonMergeSettings {
                // union array values together to avoid duplicates
                MergeArrayHandling = MergeArrayHandling.Union
            });
            Title = title;
            MessageType = messageType;
            Message = msg;
            Add("Title", title);
            Add("MessageType", (int)messageType);
            Add("Message", msg);
        }
    }
}