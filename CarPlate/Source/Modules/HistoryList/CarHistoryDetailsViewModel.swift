//
//  CarHistoryDetailsViewModel.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 28.05.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Combine

class CarHistoryDetailsViewModel: CarDetailsViewModel {
    var underlyingDetails: CarInfoDisplayModel
    private var searchByIdToken: Cancellable?

    init(details: CarInfoDisplayModel) {
        self.underlyingDetails = details
        super.init(carPlateNumber: .constant(""))
    }
    override func onViewAppear() {
        self.details = underlyingDetails
        self.isShowAllRecordsVisible = false
    }
}
