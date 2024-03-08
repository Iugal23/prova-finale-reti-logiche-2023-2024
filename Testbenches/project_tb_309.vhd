-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_309 is
end project_tb_309;

architecture project_tb_arch_309 of project_tb_309 is
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

constant SCENARIO_LENGTH : integer := 550;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (89,0,16,0,0,0,0,0,42,0,180,0,90,0,239,0,0,0,0,0,155,0,136,0,0,0,151,0,189,0,105,0,10,0,89,0,200,0,122,0,183,0,200,0,110,0,19,0,0,0,221,0,0,0,55,0,0,0,0,0,252,0,0,0,182,0,177,0,59,0,63,0,0,0,162,0,120,0,218,0,0,0,230,0,0,0,36,0,85,0,92,0,0,0,251,0,126,0,102,0,228,0,250,0,66,0,210,0,0,0,131,0,26,0,44,0,211,0,203,0,59,0,81,0,102,0,1,0,80,0,57,0,90,0,64,0,19,0,0,0,165,0,222,0,197,0,0,0,154,0,32,0,219,0,46,0,0,0,7,0,131,0,230,0,72,0,157,0,166,0,58,0,32,0,51,0,0,0,155,0,0,0,104,0,95,0,251,0,24,0,0,0,18,0,145,0,106,0,199,0,208,0,133,0,193,0,96,0,0,0,150,0,18,0,189,0,45,0,58,0,189,0,0,0,52,0,11,0,0,0,69,0,0,0,189,0,0,0,0,0,66,0,108,0,90,0,86,0,0,0,252,0,224,0,0,0,247,0,50,0,192,0,81,0,241,0,0,0,133,0,0,0,218,0,243,0,73,0,80,0,39,0,0,0,141,0,27,0,160,0,189,0,0,0,0,0,0,0,130,0,0,0,0,0,0,0,195,0,46,0,0,0,131,0,140,0,230,0,4,0,218,0,97,0,0,0,52,0,139,0,220,0,25,0,70,0,244,0,54,0,203,0,151,0,62,0,0,0,200,0,19,0,0,0,0,0,0,0,0,0,0,0,115,0,0,0,87,0,123,0,104,0,56,0,174,0,182,0,0,0,0,0,201,0,179,0,0,0,32,0,0,0,251,0,92,0,217,0,0,0,108,0,0,0,244,0,112,0,198,0,87,0,192,0,82,0,211,0,56,0,0,0,179,0,0,0,190,0,0,0,223,0,245,0,86,0,40,0,89,0,35,0,89,0,111,0,144,0,146,0,156,0,253,0,76,0,112,0,171,0,244,0,10,0,0,0,148,0,0,0,0,0,225,0,126,0,5,0,0,0,235,0,105,0,0,0,18,0,228,0,117,0,130,0,215,0,0,0,77,0,148,0,17,0,229,0,219,0,237,0,201,0,191,0,113,0,162,0,135,0,221,0,227,0,102,0,222,0,0,0,0,0,0,0,86,0,0,0,212,0,80,0,109,0,242,0,157,0,0,0,170,0,184,0,56,0,42,0,72,0,139,0,209,0,114,0,197,0,216,0,135,0,112,0,0,0,183,0,75,0,133,0,196,0,93,0,173,0,59,0,208,0,0,0,27,0,0,0,229,0,0,0,127,0,154,0,0,0,0,0,170,0,198,0,220,0,155,0,161,0,132,0,44,0,4,0,0,0,133,0,0,0,115,0,227,0,66,0,33,0,0,0,170,0,0,0,177,0,48,0,220,0,203,0,72,0,80,0,0,0,0,0,196,0,121,0,225,0,0,0,94,0,216,0,71,0,0,0,47,0,226,0,98,0,23,0,0,0,153,0,25,0,0,0,252,0,130,0,204,0,0,0,96,0,30,0,143,0,153,0,76,0,118,0,29,0,104,0,5,0,3,0,220,0,104,0,18,0,98,0,133,0,220,0,49,0,56,0,6,0,64,0,223,0,123,0,152,0,31,0,167,0,0,0,0,0,76,0,147,0,78,0,27,0,0,0,0,0,0,0,147,0,28,0,210,0,15,0,168,0,213,0,235,0,224,0,210,0,114,0,15,0,0,0,18,0,134,0,105,0,0,0,0,0,51,0,253,0,0,0,249,0,28,0,0,0,168,0,236,0,172,0,240,0,72,0,99,0,72,0,0,0,164,0,204,0,120,0,178,0,0,0,240,0,18,0,132,0,226,0,0,0,158,0,224,0,84,0,0,0,33,0,0,0,0,0,98,0,53,0,157,0,57,0,73,0,0,0,160,0,28,0,223,0,72,0,0,0,234,0,80,0,228,0,126,0,0,0,107,0,0,0,0,0,165,0,228,0,87,0,90,0,38,0,241,0,224,0,37,0,200,0,63,0,4,0,218,0,27,0,18,0,152,0,0,0,21,0,38,0,92,0,23,0,0,0,27,0,127,0,177,0,0,0,22,0,0,0,130,0,92,0,90,0,86,0,194,0,0,0,9,0,2,0,187,0,161,0,71,0,118,0,0,0,182,0,125,0,2,0,213,0,134,0,173,0,71,0,115,0,150,0,222,0,195,0,0,0,135,0,104,0,179,0,153,0,230,0,78,0,178,0,143,0,232,0,81,0,63,0,251,0,0,0,241,0,251,0,211,0,0,0,212,0,247,0,0,0,151,0,140,0,97,0,178,0,205,0,36,0,53,0,35,0,177,0,0,0,151,0,89,0,8,0,88,0,0,0,243,0,77,0,81,0,255,0,0,0,217,0,144,0,43,0,218,0,99,0,193,0);
signal scenario_full  : scenario_type := (89,31,16,31,16,30,16,29,42,31,180,31,90,31,239,31,239,30,239,29,155,31,136,31,136,30,151,31,189,31,105,31,10,31,89,31,200,31,122,31,183,31,200,31,110,31,19,31,19,30,221,31,221,30,55,31,55,30,55,29,252,31,252,30,182,31,177,31,59,31,63,31,63,30,162,31,120,31,218,31,218,30,230,31,230,30,36,31,85,31,92,31,92,30,251,31,126,31,102,31,228,31,250,31,66,31,210,31,210,30,131,31,26,31,44,31,211,31,203,31,59,31,81,31,102,31,1,31,80,31,57,31,90,31,64,31,19,31,19,30,165,31,222,31,197,31,197,30,154,31,32,31,219,31,46,31,46,30,7,31,131,31,230,31,72,31,157,31,166,31,58,31,32,31,51,31,51,30,155,31,155,30,104,31,95,31,251,31,24,31,24,30,18,31,145,31,106,31,199,31,208,31,133,31,193,31,96,31,96,30,150,31,18,31,189,31,45,31,58,31,189,31,189,30,52,31,11,31,11,30,69,31,69,30,189,31,189,30,189,29,66,31,108,31,90,31,86,31,86,30,252,31,224,31,224,30,247,31,50,31,192,31,81,31,241,31,241,30,133,31,133,30,218,31,243,31,73,31,80,31,39,31,39,30,141,31,27,31,160,31,189,31,189,30,189,29,189,28,130,31,130,30,130,29,130,28,195,31,46,31,46,30,131,31,140,31,230,31,4,31,218,31,97,31,97,30,52,31,139,31,220,31,25,31,70,31,244,31,54,31,203,31,151,31,62,31,62,30,200,31,19,31,19,30,19,29,19,28,19,27,19,26,115,31,115,30,87,31,123,31,104,31,56,31,174,31,182,31,182,30,182,29,201,31,179,31,179,30,32,31,32,30,251,31,92,31,217,31,217,30,108,31,108,30,244,31,112,31,198,31,87,31,192,31,82,31,211,31,56,31,56,30,179,31,179,30,190,31,190,30,223,31,245,31,86,31,40,31,89,31,35,31,89,31,111,31,144,31,146,31,156,31,253,31,76,31,112,31,171,31,244,31,10,31,10,30,148,31,148,30,148,29,225,31,126,31,5,31,5,30,235,31,105,31,105,30,18,31,228,31,117,31,130,31,215,31,215,30,77,31,148,31,17,31,229,31,219,31,237,31,201,31,191,31,113,31,162,31,135,31,221,31,227,31,102,31,222,31,222,30,222,29,222,28,86,31,86,30,212,31,80,31,109,31,242,31,157,31,157,30,170,31,184,31,56,31,42,31,72,31,139,31,209,31,114,31,197,31,216,31,135,31,112,31,112,30,183,31,75,31,133,31,196,31,93,31,173,31,59,31,208,31,208,30,27,31,27,30,229,31,229,30,127,31,154,31,154,30,154,29,170,31,198,31,220,31,155,31,161,31,132,31,44,31,4,31,4,30,133,31,133,30,115,31,227,31,66,31,33,31,33,30,170,31,170,30,177,31,48,31,220,31,203,31,72,31,80,31,80,30,80,29,196,31,121,31,225,31,225,30,94,31,216,31,71,31,71,30,47,31,226,31,98,31,23,31,23,30,153,31,25,31,25,30,252,31,130,31,204,31,204,30,96,31,30,31,143,31,153,31,76,31,118,31,29,31,104,31,5,31,3,31,220,31,104,31,18,31,98,31,133,31,220,31,49,31,56,31,6,31,64,31,223,31,123,31,152,31,31,31,167,31,167,30,167,29,76,31,147,31,78,31,27,31,27,30,27,29,27,28,147,31,28,31,210,31,15,31,168,31,213,31,235,31,224,31,210,31,114,31,15,31,15,30,18,31,134,31,105,31,105,30,105,29,51,31,253,31,253,30,249,31,28,31,28,30,168,31,236,31,172,31,240,31,72,31,99,31,72,31,72,30,164,31,204,31,120,31,178,31,178,30,240,31,18,31,132,31,226,31,226,30,158,31,224,31,84,31,84,30,33,31,33,30,33,29,98,31,53,31,157,31,57,31,73,31,73,30,160,31,28,31,223,31,72,31,72,30,234,31,80,31,228,31,126,31,126,30,107,31,107,30,107,29,165,31,228,31,87,31,90,31,38,31,241,31,224,31,37,31,200,31,63,31,4,31,218,31,27,31,18,31,152,31,152,30,21,31,38,31,92,31,23,31,23,30,27,31,127,31,177,31,177,30,22,31,22,30,130,31,92,31,90,31,86,31,194,31,194,30,9,31,2,31,187,31,161,31,71,31,118,31,118,30,182,31,125,31,2,31,213,31,134,31,173,31,71,31,115,31,150,31,222,31,195,31,195,30,135,31,104,31,179,31,153,31,230,31,78,31,178,31,143,31,232,31,81,31,63,31,251,31,251,30,241,31,251,31,211,31,211,30,212,31,247,31,247,30,151,31,140,31,97,31,178,31,205,31,36,31,53,31,35,31,177,31,177,30,151,31,89,31,8,31,88,31,88,30,243,31,77,31,81,31,255,31,255,30,217,31,144,31,43,31,218,31,99,31,193,31);

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
