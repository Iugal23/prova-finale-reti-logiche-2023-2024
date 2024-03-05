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

constant SCENARIO_LENGTH : integer := 438;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (125,0,33,0,80,0,126,0,0,0,200,0,2,0,105,0,84,0,10,0,70,0,98,0,116,0,101,0,199,0,0,0,114,0,125,0,201,0,229,0,40,0,240,0,66,0,25,0,141,0,0,0,0,0,119,0,165,0,0,0,128,0,242,0,39,0,18,0,40,0,188,0,197,0,0,0,0,0,234,0,76,0,220,0,164,0,4,0,157,0,0,0,197,0,20,0,119,0,152,0,235,0,119,0,97,0,19,0,203,0,85,0,143,0,175,0,96,0,212,0,8,0,178,0,179,0,31,0,0,0,226,0,114,0,139,0,0,0,164,0,194,0,57,0,24,0,0,0,80,0,190,0,0,0,32,0,0,0,0,0,231,0,229,0,63,0,172,0,0,0,6,0,0,0,245,0,66,0,240,0,179,0,0,0,144,0,233,0,88,0,234,0,76,0,213,0,174,0,211,0,125,0,255,0,255,0,85,0,108,0,0,0,171,0,72,0,161,0,0,0,43,0,85,0,92,0,0,0,219,0,130,0,119,0,28,0,0,0,135,0,0,0,0,0,133,0,18,0,43,0,79,0,38,0,178,0,210,0,98,0,84,0,226,0,40,0,181,0,13,0,10,0,74,0,8,0,0,0,223,0,79,0,102,0,0,0,36,0,0,0,0,0,48,0,0,0,105,0,85,0,0,0,59,0,44,0,134,0,168,0,98,0,0,0,84,0,236,0,242,0,0,0,33,0,155,0,203,0,176,0,0,0,22,0,0,0,58,0,107,0,14,0,204,0,0,0,62,0,0,0,251,0,16,0,203,0,172,0,152,0,0,0,0,0,0,0,205,0,31,0,144,0,31,0,184,0,219,0,72,0,106,0,0,0,0,0,18,0,220,0,229,0,109,0,253,0,84,0,25,0,123,0,163,0,196,0,237,0,167,0,0,0,153,0,0,0,26,0,169,0,97,0,0,0,0,0,31,0,94,0,181,0,0,0,51,0,12,0,192,0,77,0,252,0,171,0,129,0,26,0,160,0,0,0,51,0,252,0,236,0,199,0,0,0,0,0,0,0,56,0,252,0,0,0,211,0,0,0,82,0,131,0,0,0,125,0,42,0,199,0,72,0,1,0,10,0,133,0,80,0,33,0,224,0,0,0,221,0,0,0,113,0,96,0,0,0,0,0,212,0,70,0,0,0,10,0,124,0,30,0,124,0,0,0,213,0,175,0,28,0,131,0,165,0,109,0,7,0,244,0,221,0,0,0,239,0,82,0,151,0,202,0,85,0,0,0,12,0,28,0,143,0,179,0,56,0,101,0,114,0,148,0,204,0,229,0,133,0,218,0,131,0,136,0,245,0,0,0,64,0,0,0,174,0,200,0,249,0,228,0,20,0,188,0,173,0,146,0,0,0,200,0,208,0,182,0,159,0,0,0,23,0,185,0,30,0,0,0,56,0,78,0,167,0,22,0,196,0,242,0,96,0,94,0,59,0,21,0,84,0,43,0,111,0,75,0,0,0,194,0,11,0,248,0,173,0,0,0,181,0,252,0,0,0,0,0,188,0,150,0,35,0,70,0,14,0,59,0,0,0,188,0,195,0,25,0,177,0,235,0,92,0,8,0,211,0,206,0,193,0,0,0,142,0,0,0,128,0,219,0,60,0,148,0,213,0,97,0,159,0,0,0,18,0,37,0,80,0,0,0,238,0,17,0,177,0,169,0,185,0,16,0,122,0,1,0,219,0,189,0,182,0,100,0,161,0,88,0,180,0,181,0,83,0,134,0,65,0,0,0,255,0,218,0,241,0,45,0,0,0,0,0,15,0,56,0,107,0,0,0,0,0,0,0,138,0,0,0,47,0,105,0,16,0,48,0,69,0,0,0,175,0,193,0,52,0,251,0,231,0,227,0,75,0,184,0,108,0,253,0,16,0,181,0,49,0,42,0,234,0,78,0,216,0,0,0,8,0,0,0,157,0,13,0,245,0);
signal scenario_full  : scenario_type := (125,31,33,31,80,31,126,31,126,30,200,31,2,31,105,31,84,31,10,31,70,31,98,31,116,31,101,31,199,31,199,30,114,31,125,31,201,31,229,31,40,31,240,31,66,31,25,31,141,31,141,30,141,29,119,31,165,31,165,30,128,31,242,31,39,31,18,31,40,31,188,31,197,31,197,30,197,29,234,31,76,31,220,31,164,31,4,31,157,31,157,30,197,31,20,31,119,31,152,31,235,31,119,31,97,31,19,31,203,31,85,31,143,31,175,31,96,31,212,31,8,31,178,31,179,31,31,31,31,30,226,31,114,31,139,31,139,30,164,31,194,31,57,31,24,31,24,30,80,31,190,31,190,30,32,31,32,30,32,29,231,31,229,31,63,31,172,31,172,30,6,31,6,30,245,31,66,31,240,31,179,31,179,30,144,31,233,31,88,31,234,31,76,31,213,31,174,31,211,31,125,31,255,31,255,31,85,31,108,31,108,30,171,31,72,31,161,31,161,30,43,31,85,31,92,31,92,30,219,31,130,31,119,31,28,31,28,30,135,31,135,30,135,29,133,31,18,31,43,31,79,31,38,31,178,31,210,31,98,31,84,31,226,31,40,31,181,31,13,31,10,31,74,31,8,31,8,30,223,31,79,31,102,31,102,30,36,31,36,30,36,29,48,31,48,30,105,31,85,31,85,30,59,31,44,31,134,31,168,31,98,31,98,30,84,31,236,31,242,31,242,30,33,31,155,31,203,31,176,31,176,30,22,31,22,30,58,31,107,31,14,31,204,31,204,30,62,31,62,30,251,31,16,31,203,31,172,31,152,31,152,30,152,29,152,28,205,31,31,31,144,31,31,31,184,31,219,31,72,31,106,31,106,30,106,29,18,31,220,31,229,31,109,31,253,31,84,31,25,31,123,31,163,31,196,31,237,31,167,31,167,30,153,31,153,30,26,31,169,31,97,31,97,30,97,29,31,31,94,31,181,31,181,30,51,31,12,31,192,31,77,31,252,31,171,31,129,31,26,31,160,31,160,30,51,31,252,31,236,31,199,31,199,30,199,29,199,28,56,31,252,31,252,30,211,31,211,30,82,31,131,31,131,30,125,31,42,31,199,31,72,31,1,31,10,31,133,31,80,31,33,31,224,31,224,30,221,31,221,30,113,31,96,31,96,30,96,29,212,31,70,31,70,30,10,31,124,31,30,31,124,31,124,30,213,31,175,31,28,31,131,31,165,31,109,31,7,31,244,31,221,31,221,30,239,31,82,31,151,31,202,31,85,31,85,30,12,31,28,31,143,31,179,31,56,31,101,31,114,31,148,31,204,31,229,31,133,31,218,31,131,31,136,31,245,31,245,30,64,31,64,30,174,31,200,31,249,31,228,31,20,31,188,31,173,31,146,31,146,30,200,31,208,31,182,31,159,31,159,30,23,31,185,31,30,31,30,30,56,31,78,31,167,31,22,31,196,31,242,31,96,31,94,31,59,31,21,31,84,31,43,31,111,31,75,31,75,30,194,31,11,31,248,31,173,31,173,30,181,31,252,31,252,30,252,29,188,31,150,31,35,31,70,31,14,31,59,31,59,30,188,31,195,31,25,31,177,31,235,31,92,31,8,31,211,31,206,31,193,31,193,30,142,31,142,30,128,31,219,31,60,31,148,31,213,31,97,31,159,31,159,30,18,31,37,31,80,31,80,30,238,31,17,31,177,31,169,31,185,31,16,31,122,31,1,31,219,31,189,31,182,31,100,31,161,31,88,31,180,31,181,31,83,31,134,31,65,31,65,30,255,31,218,31,241,31,45,31,45,30,45,29,15,31,56,31,107,31,107,30,107,29,107,28,138,31,138,30,47,31,105,31,16,31,48,31,69,31,69,30,175,31,193,31,52,31,251,31,231,31,227,31,75,31,184,31,108,31,253,31,16,31,181,31,49,31,42,31,234,31,78,31,216,31,216,30,8,31,8,30,157,31,13,31,245,31);

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
