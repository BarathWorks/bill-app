import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base use case interface for Clean Architecture
/// 
/// Type: The return type of the use case
/// Params: The parameters required by the use case (use NoParams if none needed)
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use when a use case doesn't require any parameters
class NoParams {
  const NoParams();
}
