class AddBeatCodeToAgent < ActiveRecord::Migration[5.0]
  def change
    add_column :agents, :beat_code, :string
    Agent.where(lga: "Akoko-Edo").update_all(beat_code: "ED1/1")
    Agent.where(lga: "Egor").update_all(beat_code: "ED2/1")
    Agent.where(lga: "Esan Central").update_all(beat_code: "ED3/1")
    Agent.where(lga: "Esan North-East").update_all(beat_code: "ED4/1")
    Agent.where(lga: "Esan South-East").update_all(beat_code: "ED15/1")
    Agent.where(lga: "Esan West").update_all(beat_code: "ED6/1")
    Agent.where(lga: "Etsako Central").update_all(beat_code: "ED7/1")
    Agent.where(lga: "Etsako East").update_all(beat_code: "ED8/1")
    Agent.where(lga: "Etsako West").update_all(beat_code: "ED9/1")
    Agent.where(lga: "Igueben").update_all(beat_code: "ED10/1")
    Agent.where(lga: "Ikpoba-Okha").update_all(beat_code: "ED11/1")
    Agent.where(lga: "Oredo").update_all(beat_code: "ED12/1")
    Agent.where(lga: "Orhionmwon").update_all(beat_code: "ED13/1")
    Agent.where(lga: "Ovia North-East").update_all(beat_code: "ED14/1")
    Agent.where(lga: "Ovia South-West").update_all(beat_code: "ED15/1")
    Agent.where(lga: "Owan East").update_all(beat_code: "ED16/1")
    Agent.where(lga: "Owan West").update_all(beat_code: "ED17/1")
    Agent.where(lga: "Uhunmwonde").update_all(beat_code: "ED18/1")
  end
end
