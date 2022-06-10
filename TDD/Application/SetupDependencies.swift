//
// Created by Mickael Belhassen on 14/03/2022.
//

import Foundation

extension DependencyFactory {

    public override func registerDependencies() {
        registerServices()
        registerRepositories()
        registerViewModels()
        registerViewStates()
        registerCoordinators()
        registerAPIs()
    }

    private func registerServices() {
        register(DatabaseManagerService.self, instanceType: .single) { _ in DatabaseManager() }
        register(BackgroundTasksManagerService.self, instanceType: .single) { r in
            BackgroundTasksManager(synchronizes: [r.resolve(CustomerRepositoryService.self) as! Synchronizable])
        }
    }

    private func registerRepositories() {
        register(CustomerRepositoryService.self) { r in r.autoResolve(CustomerRepository.init) }
        register(PostRepositoryService.self) { r in r.autoResolve(PostRepository.init) }
    }

    private func registerViewModels() {
        register { r in r.autoResolve(AddCustomerViewModel.init) }
        register(CustomersListViewModel.self) { r in r.autoResolve(CustomersListViewModel.init) }
        register { r in r.autoResolve(CustomerProfileViewModel.init) }
    }

    private func registerViewStates() {
        register { r in r.autoResolve(CustomerListViewState.init) }
    }

    private func registerCoordinators() {
        register(CustomerListCoordinatorService.self) { _ in CustomerListCoordinator() }
        register(AddCustomerCoordinatorService.self) { _ in AddCustomerCoordinator() }
    }

    private func registerAPIs() {
        register(NetworkingService.self, instanceType: .single) { _ in Networking() }
        register(APIService.self, instanceType: .single) { r in r.autoResolve(API.init) }
        register(CustomerAPIClientService.self, instanceType: .single) { r in r.autoResolve(CustomerAPIClient.init) }
        register(PostAPIClientService.self, instanceType: .single) { r in r.autoResolve(PostAPIClient.init) }
    }

}
