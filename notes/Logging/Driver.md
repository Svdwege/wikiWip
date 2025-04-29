# Driver

The logging library currently accepts a u8 array or a object which inherits from `Ilogable_object`.
This ensures that a `toString()` method is implemented for the data which needs to be logged.
Then call the `logger.logData()` method with the object carrying the data.

The loggable object can be made using the composite design pattern.
However it might be overcomplicating it, so to keep it simple for the first prototype the loggable data will be a single object with all info as properties.
Where `toString()` calls the subobjects to `toString()` functions to create a string representation of the composite object.
