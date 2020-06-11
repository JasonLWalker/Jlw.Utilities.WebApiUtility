namespace Jlw.Standard.Utilities.WebApiUtility
{
    /// <summary>
    /// Enumeration of Message types. With the exception of the Redirect, these correspond to the Bootstrap 3 and Toastr message class types.
    /// </summary>
    public enum ApiMessageType
    {
        Success,
        Warning,
        Info,
        Danger,
        Alert,
        Redirect
    }
}