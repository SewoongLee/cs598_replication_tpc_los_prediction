from eICU_preprocessing.split_train_test import create_folder
from torch.optim import Adam
from torch.optim import SGD
from models.tpc_model import TempPointConv
from models.experiment_template import ExperimentTemplate
from models.experiment_template import write_paths_to_json
from models.initialise_arguments import initialise_tpc_arguments


class TPC(ExperimentTemplate):
    def setup(self):
        self.setup_template()

        write_paths_to_json(self.config["model_type"], self.elog)

        self.model = TempPointConv(config=self.config,
                                   F=self.train_datareader.F,
                                   D=self.train_datareader.D,
                                   no_flat_features=self.train_datareader.no_flat_features).to(device=self.device)
        self.elog.print(self.model)

        if self.config["optim"] == "SGD":
            self.optimiser = SGD(self.model.parameters(), lr=self.config.learning_rate, weight_decay=self.config.L2_regularisation)
        else:
            self.optimiser = Adam(self.model.parameters(), lr=self.config.learning_rate, weight_decay=self.config.L2_regularisation)
        
        return


def run_tpc():

    c = initialise_tpc_arguments()

    c['exp_name'] = 'TPC'
    
    log_folder_path = create_folder('models/experiments/{}/{}'.format(c.dataset, c.task), c.exp_name)

    tpc = TPC(config=c,
              n_epochs=c.n_epochs,
              name=c.exp_name,
              base_dir=log_folder_path,
              explogger_kwargs={'folder_format': '%Y-%m-%d_%H%M%S{run_number}'})
    
    tpc.run()


if __name__=='__main__':
    
    run_tpc()
