abstract class DomainMapper<T,DomainModel> {

  DomainModel mapFromDomainModel(T model);

  T mapToDomainModel(DomainModel domainModel);
}