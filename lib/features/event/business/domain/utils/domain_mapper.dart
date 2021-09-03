abstract class DomainMapper<T,DomainModel> {

  DomainModel mapToDomainModel(T model);

  T mapFromDomainModel(DomainModel domainModel);
}