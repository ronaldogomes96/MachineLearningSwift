
#Faz o import do turicreate no sistema
import turicreate as tc

#Isso carregará os dados do arquivo JSON em um SFrame, 
#que é o contêiner de dados do Turi Create. 
data = tc.SFrame.read_json('corpus.json', orient = 'records')

#Mostra os dados do dataset na tela
print(data)

#Isso cria um classificador de texto, considerando os dados carregados, 
#especificando os authorrótulos da classe e a textcoluna como 
#a variável de entrada
#Este comando cria o modelo e o treina data.
model = tc.text_classifier.create(data, 'author', features=['text'])

#exportar o modelo no formato Core ML
model.export_coreml ('Poets.mlmodel')