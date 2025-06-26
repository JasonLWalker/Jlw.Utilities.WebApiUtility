namespace Jlw.Utilities.WebApiUtility
{
    /// <summary>
    /// API Response used when an HTTP Status 401 - Unauthorized needs to be sent.
    /// Used to create a default message to use with .NET ProducesResponseType attribute
    /// </summary>
    public sealed class ApiUnauthorizedResponse : IApiStatusMessage
    {
        /// <summary>User-friendly message</summary>
        /// <example>You either have not logged in, or your session has expired</example>
        public string Message { get; } = "You either have not logged in, or your session has expired";
        ///<summary>The message type</summary>
        /// <see cref="ApiMessageType"/>
        /// <example>3</example>
        public ApiMessageType MessageType { get; } = ApiMessageType.Danger;
        /// <summary>A short title for messageboxes</summary>
        /// <example>Not logged in</example>
        public string Title { get; } = "Not Logged in";

        public ApiUnauthorizedResponse()
        {
            // Default constructor
        }
    }
}
