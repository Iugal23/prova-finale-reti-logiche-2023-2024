-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 444;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (2,0,27,0,38,0,222,0,0,0,74,0,191,0,25,0,78,0,186,0,113,0,107,0,82,0,69,0,107,0,124,0,0,0,108,0,113,0,87,0,142,0,220,0,92,0,156,0,53,0,216,0,107,0,9,0,250,0,0,0,0,0,0,0,69,0,111,0,192,0,17,0,238,0,178,0,0,0,0,0,48,0,0,0,67,0,133,0,94,0,236,0,204,0,0,0,124,0,0,0,99,0,184,0,146,0,207,0,225,0,255,0,158,0,105,0,0,0,140,0,144,0,135,0,202,0,43,0,0,0,155,0,217,0,72,0,233,0,213,0,0,0,63,0,59,0,185,0,198,0,22,0,0,0,20,0,0,0,30,0,220,0,101,0,150,0,204,0,90,0,42,0,99,0,232,0,75,0,6,0,0,0,31,0,74,0,147,0,57,0,0,0,60,0,0,0,143,0,239,0,165,0,131,0,0,0,0,0,88,0,1,0,105,0,54,0,0,0,128,0,252,0,52,0,70,0,216,0,0,0,189,0,21,0,26,0,0,0,233,0,0,0,249,0,91,0,184,0,19,0,201,0,140,0,0,0,72,0,0,0,251,0,173,0,0,0,104,0,140,0,128,0,121,0,89,0,98,0,36,0,131,0,198,0,213,0,162,0,254,0,53,0,0,0,168,0,88,0,112,0,0,0,0,0,204,0,0,0,9,0,81,0,152,0,48,0,67,0,174,0,202,0,0,0,85,0,7,0,66,0,16,0,160,0,143,0,125,0,244,0,169,0,38,0,107,0,59,0,220,0,48,0,191,0,6,0,215,0,46,0,114,0,36,0,0,0,148,0,0,0,227,0,184,0,108,0,237,0,0,0,88,0,52,0,241,0,86,0,92,0,0,0,250,0,87,0,30,0,251,0,226,0,158,0,0,0,65,0,208,0,117,0,232,0,247,0,88,0,109,0,0,0,149,0,0,0,0,0,9,0,213,0,189,0,39,0,9,0,91,0,148,0,0,0,61,0,23,0,65,0,0,0,184,0,202,0,0,0,233,0,115,0,50,0,158,0,77,0,0,0,7,0,141,0,76,0,208,0,80,0,191,0,0,0,97,0,0,0,239,0,0,0,8,0,0,0,24,0,150,0,169,0,0,0,252,0,168,0,54,0,41,0,86,0,162,0,236,0,38,0,140,0,126,0,248,0,226,0,50,0,202,0,49,0,118,0,66,0,192,0,0,0,68,0,3,0,74,0,0,0,0,0,254,0,149,0,189,0,67,0,88,0,48,0,138,0,138,0,209,0,134,0,4,0,71,0,189,0,5,0,0,0,116,0,53,0,0,0,92,0,168,0,0,0,113,0,0,0,242,0,156,0,131,0,0,0,245,0,7,0,0,0,169,0,32,0,0,0,5,0,233,0,102,0,236,0,229,0,243,0,201,0,182,0,44,0,70,0,84,0,128,0,36,0,140,0,14,0,157,0,65,0,75,0,0,0,76,0,200,0,0,0,39,0,13,0,42,0,0,0,0,0,176,0,164,0,92,0,102,0,0,0,120,0,65,0,39,0,199,0,212,0,0,0,131,0,189,0,0,0,164,0,171,0,192,0,166,0,85,0,25,0,53,0,0,0,123,0,9,0,7,0,0,0,70,0,119,0,164,0,244,0,0,0,127,0,20,0,0,0,0,0,168,0,176,0,189,0,79,0,0,0,108,0,0,0,142,0,90,0,14,0,2,0,219,0,235,0,91,0,189,0,155,0,209,0,26,0,0,0,178,0,216,0,0,0,29,0,137,0,10,0,0,0,2,0,11,0,0,0,0,0,122,0,73,0,14,0,98,0,0,0,0,0,235,0,207,0,95,0,254,0,119,0,211,0,51,0,52,0,106,0,223,0,12,0,164,0,0,0,7,0,62,0,0,0,77,0,208,0,236,0,133,0,0,0,2,0,55,0,212,0,0,0,109,0,20,0,152,0,9,0,230,0,228,0,114,0,196,0,40,0,0,0,0,0,248,0);
signal scenario_full  : scenario_type := (2,31,27,31,38,31,222,31,222,30,74,31,191,31,25,31,78,31,186,31,113,31,107,31,82,31,69,31,107,31,124,31,124,30,108,31,113,31,87,31,142,31,220,31,92,31,156,31,53,31,216,31,107,31,9,31,250,31,250,30,250,29,250,28,69,31,111,31,192,31,17,31,238,31,178,31,178,30,178,29,48,31,48,30,67,31,133,31,94,31,236,31,204,31,204,30,124,31,124,30,99,31,184,31,146,31,207,31,225,31,255,31,158,31,105,31,105,30,140,31,144,31,135,31,202,31,43,31,43,30,155,31,217,31,72,31,233,31,213,31,213,30,63,31,59,31,185,31,198,31,22,31,22,30,20,31,20,30,30,31,220,31,101,31,150,31,204,31,90,31,42,31,99,31,232,31,75,31,6,31,6,30,31,31,74,31,147,31,57,31,57,30,60,31,60,30,143,31,239,31,165,31,131,31,131,30,131,29,88,31,1,31,105,31,54,31,54,30,128,31,252,31,52,31,70,31,216,31,216,30,189,31,21,31,26,31,26,30,233,31,233,30,249,31,91,31,184,31,19,31,201,31,140,31,140,30,72,31,72,30,251,31,173,31,173,30,104,31,140,31,128,31,121,31,89,31,98,31,36,31,131,31,198,31,213,31,162,31,254,31,53,31,53,30,168,31,88,31,112,31,112,30,112,29,204,31,204,30,9,31,81,31,152,31,48,31,67,31,174,31,202,31,202,30,85,31,7,31,66,31,16,31,160,31,143,31,125,31,244,31,169,31,38,31,107,31,59,31,220,31,48,31,191,31,6,31,215,31,46,31,114,31,36,31,36,30,148,31,148,30,227,31,184,31,108,31,237,31,237,30,88,31,52,31,241,31,86,31,92,31,92,30,250,31,87,31,30,31,251,31,226,31,158,31,158,30,65,31,208,31,117,31,232,31,247,31,88,31,109,31,109,30,149,31,149,30,149,29,9,31,213,31,189,31,39,31,9,31,91,31,148,31,148,30,61,31,23,31,65,31,65,30,184,31,202,31,202,30,233,31,115,31,50,31,158,31,77,31,77,30,7,31,141,31,76,31,208,31,80,31,191,31,191,30,97,31,97,30,239,31,239,30,8,31,8,30,24,31,150,31,169,31,169,30,252,31,168,31,54,31,41,31,86,31,162,31,236,31,38,31,140,31,126,31,248,31,226,31,50,31,202,31,49,31,118,31,66,31,192,31,192,30,68,31,3,31,74,31,74,30,74,29,254,31,149,31,189,31,67,31,88,31,48,31,138,31,138,31,209,31,134,31,4,31,71,31,189,31,5,31,5,30,116,31,53,31,53,30,92,31,168,31,168,30,113,31,113,30,242,31,156,31,131,31,131,30,245,31,7,31,7,30,169,31,32,31,32,30,5,31,233,31,102,31,236,31,229,31,243,31,201,31,182,31,44,31,70,31,84,31,128,31,36,31,140,31,14,31,157,31,65,31,75,31,75,30,76,31,200,31,200,30,39,31,13,31,42,31,42,30,42,29,176,31,164,31,92,31,102,31,102,30,120,31,65,31,39,31,199,31,212,31,212,30,131,31,189,31,189,30,164,31,171,31,192,31,166,31,85,31,25,31,53,31,53,30,123,31,9,31,7,31,7,30,70,31,119,31,164,31,244,31,244,30,127,31,20,31,20,30,20,29,168,31,176,31,189,31,79,31,79,30,108,31,108,30,142,31,90,31,14,31,2,31,219,31,235,31,91,31,189,31,155,31,209,31,26,31,26,30,178,31,216,31,216,30,29,31,137,31,10,31,10,30,2,31,11,31,11,30,11,29,122,31,73,31,14,31,98,31,98,30,98,29,235,31,207,31,95,31,254,31,119,31,211,31,51,31,52,31,106,31,223,31,12,31,164,31,164,30,7,31,62,31,62,30,77,31,208,31,236,31,133,31,133,30,2,31,55,31,212,31,212,30,109,31,20,31,152,31,9,31,230,31,228,31,114,31,196,31,40,31,40,30,40,29,248,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
