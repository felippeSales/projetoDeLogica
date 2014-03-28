open util/ordering [Time]

module AssistenciaHospitalar

-- Plataforma tem que ser linux, predicado para verificar isso, tem que ter uma assinatura de sistema
-- O sistema vai ter uma linha com o paciente e vai ter que checar se o paciente tem acesso ao servidor
-- O gerente vai ser um medico, e sao imutaveis

sig Time{}

sig SistemaDeAssistenciaHospitalar{
	gerente: some Medico,
	medico: some Medico,
	paciente: set Paciente
}

sig Paciente{
	data: one DataDeNascimento,
	nomePaciente: one Nome,
	sintomas: set Sintoma,
	emailPaciente: one Email,
	loginPaciente: one Login,
	senhaPaciente: one Senha,
	sistemaPaciente: one Sistema
}

sig Medico{
	pacientes: some Paciente,
	senhaMedico: one Senha,
	nomeMedico: one Nome,
	emailMedico: one Email,
	loginMedico: one Login
	
}

sig Sistema{
	temAcesso: one StatusInternet
}

abstract sig StatusInternet{}

one sig ComAcesso, SemAcesso extends StatusInternet{}

sig Plataforma{}

sig Linux extends Plataforma{}

sig Senha{}

sig Login{}

sig Nome{}	

sig Email{}

sig DataDeNascimento{}

sig Sintoma{}

///////////////////////////////////////////////////////FATOS///////////////////////////////////////////////////////

fact fatosPaciente{
	all p1:Paciente, p2:Paciente-p1 | p1.emailPaciente != p2.emailPaciente
	all p1:Paciente, p2:Paciente-p1 | p1.loginPaciente != p2.loginPaciente
	all p1:Paciente |  p1 in SistemaDeAssistenciaHospitalar.paciente
	all p1:Paciente | p1 in Medico.pacientes
}

fact fatosMedico{
	all m1:Medico | #m1.pacientes < 3
	all m1:Medico | m1 in SistemaDeAssistenciaHospitalar.medico
	all m1:Medico, m2:Medico-m1 | m1.loginMedico != m2.loginMedico
	all m1:Medico, m2:Medico-m1 | m1.emailMedico != m2.emailMedico
}

fact fatosSistemaCliente{
	all s:Sistema, p:Paciente | s in p.sistemaPaciente
}

fact fatosSistemaServidor{
    #SistemaDeAssistenciaHospitalar = 1
	all s1:SistemaDeAssistenciaHospitalar | #s1.gerente = 2
	all g1:Medico | g1 in Medico
	all g1:Medico, g2: Medico - g1 | g1 != g2
	all m1:Medico, p1:Paciente| m1.emailMedico != p1.emailPaciente
	all m1:Medico, p1:Paciente| m1.loginMedico != p1.loginPaciente
}

fact fatosNome{
	--Todo nome está vinculada a um aluno
	all n:Nome | n in Paciente.nomePaciente + Medico.nomeMedico
}

fact fatosSenha{
	all s:Senha | s in Paciente.senhaPaciente + Medico.senhaMedico
}

fact fatosLogin{
	all l:Login | l in Paciente.loginPaciente + Medico.loginMedico
}

fact fatosDataDeNascimento{
	all d:DataDeNascimento | d in Paciente.data
}

fact fatosEmail{
	all e:Email | e in Paciente.emailPaciente + Medico.emailMedico
}

fact fatosSintomas{
	all si:Sintoma | si in Paciente.sintomas
}
pred show[]{}

run show for 5
