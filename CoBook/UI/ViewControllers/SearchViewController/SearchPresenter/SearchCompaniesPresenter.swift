//
//  SearchCompaniesPresenter.swift
//  CoBook
//
//  Created by Bogdan Protas on 14.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation


class SearchCompaniesPresenter: SearchPresenter {
    
    weak var view: SearchView?
    private var viewDataSource: TableDataSource<SearchCellsConfigurator>?
    
    private var companies: [CompanyApiModel] = []
    private var filteredCompanies: [CompanyApiModel] = []
    
    var isMultiselectEnabled: Bool = false
    var selectionCompletion: ((_ practice: CompanyApiModel?) -> Void)?
    
    private var selectedCompany: CompanyApiModel?
    
    init(selectedCompany: CompanyApiModel?) {
        var configurator = SearchCellsConfigurator()
        configurator.companiesConfigurator = TableCellConfigurator(configurator: { (cell, model: CompanyApiModel, tableView, index) -> FilterItemTableViewCell in
            cell.titleLabel?.text = model.name
            return cell
        })
        self.viewDataSource = TableDataSource(sections: [], configurator: configurator)
        self.selectedCompany = selectedCompany
    }
    
    func setup() {
        view?.set(dataSource: viewDataSource)
        fetchCompanies()
    }
    
    func prepareForDismiss() {
        selectionCompletion?(selectedCompany)
    }
    
    func searchBy(text: String?) {
        guard let text = text, !text.isEmpty else {
            filteredCompanies = companies
            selectedCompany = nil
            updateViewDataSource()
            view?.reload()
            return
        }
        
        filteredCompanies = companies.filter { ($0.name ?? "").lowercased().contains(text.lowercased()) }
        updateViewDataSource()
        view?.reload()
    }
    
    func selectedAt(indexPath: IndexPath, completion: ((Bool) -> Void)?) {
        if let index = companies.firstIndex(where: { $0.id == filteredCompanies[safe: indexPath.item]?.id }) {
            selectedCompany = companies[index]
            completion?(true)
        }
    }
    
    func deselectedAt(indexPath: IndexPath, completion: ((Bool) -> Void)?) {
        
    }
    
    
}

// MARK: - Privates

private extension SearchCompaniesPresenter {

    func fetchCompanies() {
        view?.startLoading()
        APIClient.default.getCompanies(name: nil) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.stopLoading()
            switch result {
            case .success(let response):
                self.companies = (response ?? []).compactMap { CompanyApiModel(id: $0.id, name: $0.company?.name) }
                self.companies.sort { (a, b) -> Bool in
                    let titleOne = a.name ?? ""
                    let titleTwo = b.name ?? ""
                    return titleOne.localizedCaseInsensitiveCompare(titleTwo) == .orderedAscending
                }
                self.updateViewDataSource()
                if let name = self.selectedCompany?.name {
                    self.view?.set(searchBarText: name)
                } else {
                    self.view?.reload()
                }
            case .failure(let erorr):
                self.view?.errorAlert(message: erorr.localizedDescription)
            }
        }
    }


}

// MARK: - View updating

extension SearchCompaniesPresenter {

    func updateViewDataSource() {
        let companiesSection = Section<SearchContent.Item>(items: filteredCompanies.compactMap { .company(model: $0) })
        viewDataSource?.sections = [companiesSection]
    }


}
