using Jlw.Utilities.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace Jlw.Standard.Utilities.WebApiUtility
{
    /// <summary>
    /// An Api Message that is used to encapsulate an Exception, This is a similar format to that returned by JSON serialization of an exception.
    /// </summary>
    public interface IApiExceptionMessage : IApiRedirectMessage
    {
        /// <summary>
        /// The message specific to the exception
        /// </summary>
        [JsonProperty("ExceptionMessage", NamingStrategyType = typeof(DefaultNamingStrategy), ItemConverterType = typeof(JlwJsonConverter<string>))]
        string ExceptionMessage { get; }

        /// <summary>
        /// The exception type
        /// </summary>
        [JsonProperty("ExceptionType", NamingStrategyType = typeof(DefaultNamingStrategy), ItemConverterType = typeof(JlwJsonConverter<string>))]
        string ExceptionType { get; }
    }
}