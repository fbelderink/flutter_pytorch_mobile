import torch
import torch.nn as nn

class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        self.fc = nn.Linear(4,1)

    def forward(self, X):
        #shape -> [1,2,2], shape[0] is batch_size
        X = X.view(X.shape[0], -1)
        return torch.sigmoid(self.fc(X))

if __name__ == "__main__":
    model = Net()
    model.eval()
    example = torch.rand(1,2,2) #tensor of size input_shape
    traced_script_module = torch.jit.trace(model, example)
    traced_script_module.save("example/assets/models/custom_model.pt")