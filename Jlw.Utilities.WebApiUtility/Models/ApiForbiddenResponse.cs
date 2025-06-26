namespace Jlw.Utilities.WebApiUtility
{
    /// <summary>
    /// API Response used when an HTTP Status 403 - Forbidden needs to be sent.
    /// Used to create a default message to use with .NET ProducesResponseType attribute
    /// </summary>
    public class ApiForbiddenResponse : IApiStatusMessage
    {
        /// <summary>Default User-friendly message</summary>
        /// <example>You are not authorized to access this area</example>
        public string Message { get; } = "You are not authorized to access this area";
        ///<summary>The message type</summary>
        /// <see cref="ApiMessageType"/>
        /// <example>3</example>
        public ApiMessageType MessageType { get; } = ApiMessageType.Danger;
        /// <summary>A short title for messageboxes</summary>
        /// <example>Forbidden</example>
        public string Title { get; } = "Forbidden";
        
        public ApiForbiddenResponse()
        {
            // Default constructor
        }
    }
}
