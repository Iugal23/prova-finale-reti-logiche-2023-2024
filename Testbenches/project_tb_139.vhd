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

constant SCENARIO_LENGTH : integer := 527;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (143,0,0,0,53,0,102,0,40,0,147,0,214,0,183,0,213,0,0,0,0,0,162,0,0,0,21,0,66,0,17,0,0,0,189,0,0,0,0,0,190,0,0,0,62,0,80,0,213,0,39,0,36,0,66,0,0,0,166,0,17,0,167,0,51,0,240,0,0,0,99,0,0,0,0,0,114,0,238,0,169,0,169,0,0,0,98,0,136,0,43,0,0,0,53,0,75,0,233,0,215,0,88,0,13,0,77,0,147,0,117,0,195,0,83,0,0,0,22,0,193,0,215,0,76,0,140,0,154,0,0,0,120,0,19,0,254,0,195,0,137,0,158,0,90,0,56,0,36,0,154,0,81,0,74,0,249,0,0,0,0,0,254,0,208,0,80,0,232,0,0,0,126,0,0,0,164,0,0,0,248,0,21,0,92,0,212,0,166,0,158,0,121,0,240,0,140,0,0,0,2,0,198,0,62,0,99,0,108,0,248,0,7,0,111,0,106,0,228,0,223,0,135,0,235,0,15,0,220,0,193,0,0,0,232,0,102,0,248,0,51,0,226,0,0,0,0,0,215,0,170,0,103,0,41,0,233,0,81,0,107,0,23,0,214,0,49,0,95,0,204,0,165,0,119,0,85,0,0,0,135,0,154,0,0,0,232,0,73,0,89,0,251,0,11,0,11,0,0,0,68,0,92,0,209,0,121,0,0,0,141,0,160,0,0,0,138,0,236,0,198,0,181,0,24,0,0,0,221,0,131,0,0,0,40,0,149,0,25,0,145,0,7,0,245,0,18,0,202,0,25,0,231,0,32,0,193,0,20,0,141,0,0,0,71,0,190,0,10,0,110,0,134,0,64,0,64,0,0,0,0,0,130,0,78,0,155,0,180,0,0,0,224,0,120,0,0,0,76,0,213,0,169,0,233,0,0,0,98,0,147,0,173,0,238,0,188,0,0,0,0,0,95,0,96,0,135,0,55,0,224,0,156,0,0,0,42,0,43,0,0,0,180,0,236,0,0,0,183,0,179,0,84,0,0,0,7,0,65,0,0,0,246,0,63,0,0,0,101,0,37,0,5,0,161,0,0,0,25,0,203,0,163,0,171,0,133,0,145,0,187,0,0,0,165,0,236,0,172,0,0,0,15,0,226,0,242,0,30,0,0,0,3,0,0,0,218,0,133,0,94,0,0,0,0,0,0,0,254,0,119,0,113,0,183,0,0,0,0,0,0,0,192,0,0,0,48,0,0,0,227,0,89,0,144,0,0,0,173,0,0,0,73,0,132,0,97,0,147,0,2,0,115,0,0,0,57,0,210,0,207,0,255,0,0,0,134,0,0,0,0,0,102,0,96,0,142,0,197,0,0,0,50,0,178,0,56,0,77,0,195,0,68,0,229,0,191,0,50,0,38,0,0,0,0,0,0,0,150,0,208,0,105,0,0,0,71,0,138,0,117,0,41,0,238,0,206,0,26,0,15,0,203,0,0,0,123,0,124,0,0,0,199,0,33,0,251,0,217,0,229,0,208,0,125,0,223,0,140,0,0,0,109,0,112,0,113,0,39,0,65,0,83,0,4,0,0,0,114,0,93,0,140,0,102,0,22,0,199,0,237,0,85,0,5,0,70,0,0,0,93,0,202,0,66,0,184,0,58,0,58,0,221,0,233,0,22,0,0,0,0,0,71,0,40,0,142,0,149,0,243,0,23,0,0,0,253,0,37,0,158,0,188,0,147,0,167,0,232,0,98,0,27,0,0,0,96,0,237,0,3,0,16,0,179,0,69,0,47,0,194,0,253,0,78,0,0,0,194,0,167,0,237,0,1,0,205,0,184,0,14,0,93,0,204,0,204,0,4,0,188,0,66,0,247,0,194,0,60,0,0,0,129,0,95,0,0,0,10,0,108,0,0,0,64,0,0,0,230,0,169,0,0,0,89,0,4,0,0,0,0,0,0,0,158,0,38,0,150,0,0,0,139,0,179,0,105,0,214,0,225,0,252,0,151,0,74,0,67,0,0,0,0,0,85,0,0,0,245,0,126,0,192,0,75,0,0,0,52,0,102,0,0,0,119,0,191,0,215,0,120,0,191,0,84,0,167,0,191,0,209,0,40,0,26,0,219,0,53,0,12,0,56,0,101,0,0,0,57,0,218,0,33,0,79,0,36,0,86,0,39,0,74,0,232,0,0,0,0,0,194,0,0,0,41,0,197,0,216,0,255,0,102,0,29,0,178,0,127,0,7,0,13,0,70,0,166,0,127,0,0,0,0,0,0,0,3,0,0,0,113,0,0,0,162,0,193,0,183,0,0,0,0,0,19,0,134,0,4,0,34,0,0,0,141,0,46,0,0,0,2,0,253,0,25,0,233,0,0,0,103,0,57,0);
signal scenario_full  : scenario_type := (143,31,143,30,53,31,102,31,40,31,147,31,214,31,183,31,213,31,213,30,213,29,162,31,162,30,21,31,66,31,17,31,17,30,189,31,189,30,189,29,190,31,190,30,62,31,80,31,213,31,39,31,36,31,66,31,66,30,166,31,17,31,167,31,51,31,240,31,240,30,99,31,99,30,99,29,114,31,238,31,169,31,169,31,169,30,98,31,136,31,43,31,43,30,53,31,75,31,233,31,215,31,88,31,13,31,77,31,147,31,117,31,195,31,83,31,83,30,22,31,193,31,215,31,76,31,140,31,154,31,154,30,120,31,19,31,254,31,195,31,137,31,158,31,90,31,56,31,36,31,154,31,81,31,74,31,249,31,249,30,249,29,254,31,208,31,80,31,232,31,232,30,126,31,126,30,164,31,164,30,248,31,21,31,92,31,212,31,166,31,158,31,121,31,240,31,140,31,140,30,2,31,198,31,62,31,99,31,108,31,248,31,7,31,111,31,106,31,228,31,223,31,135,31,235,31,15,31,220,31,193,31,193,30,232,31,102,31,248,31,51,31,226,31,226,30,226,29,215,31,170,31,103,31,41,31,233,31,81,31,107,31,23,31,214,31,49,31,95,31,204,31,165,31,119,31,85,31,85,30,135,31,154,31,154,30,232,31,73,31,89,31,251,31,11,31,11,31,11,30,68,31,92,31,209,31,121,31,121,30,141,31,160,31,160,30,138,31,236,31,198,31,181,31,24,31,24,30,221,31,131,31,131,30,40,31,149,31,25,31,145,31,7,31,245,31,18,31,202,31,25,31,231,31,32,31,193,31,20,31,141,31,141,30,71,31,190,31,10,31,110,31,134,31,64,31,64,31,64,30,64,29,130,31,78,31,155,31,180,31,180,30,224,31,120,31,120,30,76,31,213,31,169,31,233,31,233,30,98,31,147,31,173,31,238,31,188,31,188,30,188,29,95,31,96,31,135,31,55,31,224,31,156,31,156,30,42,31,43,31,43,30,180,31,236,31,236,30,183,31,179,31,84,31,84,30,7,31,65,31,65,30,246,31,63,31,63,30,101,31,37,31,5,31,161,31,161,30,25,31,203,31,163,31,171,31,133,31,145,31,187,31,187,30,165,31,236,31,172,31,172,30,15,31,226,31,242,31,30,31,30,30,3,31,3,30,218,31,133,31,94,31,94,30,94,29,94,28,254,31,119,31,113,31,183,31,183,30,183,29,183,28,192,31,192,30,48,31,48,30,227,31,89,31,144,31,144,30,173,31,173,30,73,31,132,31,97,31,147,31,2,31,115,31,115,30,57,31,210,31,207,31,255,31,255,30,134,31,134,30,134,29,102,31,96,31,142,31,197,31,197,30,50,31,178,31,56,31,77,31,195,31,68,31,229,31,191,31,50,31,38,31,38,30,38,29,38,28,150,31,208,31,105,31,105,30,71,31,138,31,117,31,41,31,238,31,206,31,26,31,15,31,203,31,203,30,123,31,124,31,124,30,199,31,33,31,251,31,217,31,229,31,208,31,125,31,223,31,140,31,140,30,109,31,112,31,113,31,39,31,65,31,83,31,4,31,4,30,114,31,93,31,140,31,102,31,22,31,199,31,237,31,85,31,5,31,70,31,70,30,93,31,202,31,66,31,184,31,58,31,58,31,221,31,233,31,22,31,22,30,22,29,71,31,40,31,142,31,149,31,243,31,23,31,23,30,253,31,37,31,158,31,188,31,147,31,167,31,232,31,98,31,27,31,27,30,96,31,237,31,3,31,16,31,179,31,69,31,47,31,194,31,253,31,78,31,78,30,194,31,167,31,237,31,1,31,205,31,184,31,14,31,93,31,204,31,204,31,4,31,188,31,66,31,247,31,194,31,60,31,60,30,129,31,95,31,95,30,10,31,108,31,108,30,64,31,64,30,230,31,169,31,169,30,89,31,4,31,4,30,4,29,4,28,158,31,38,31,150,31,150,30,139,31,179,31,105,31,214,31,225,31,252,31,151,31,74,31,67,31,67,30,67,29,85,31,85,30,245,31,126,31,192,31,75,31,75,30,52,31,102,31,102,30,119,31,191,31,215,31,120,31,191,31,84,31,167,31,191,31,209,31,40,31,26,31,219,31,53,31,12,31,56,31,101,31,101,30,57,31,218,31,33,31,79,31,36,31,86,31,39,31,74,31,232,31,232,30,232,29,194,31,194,30,41,31,197,31,216,31,255,31,102,31,29,31,178,31,127,31,7,31,13,31,70,31,166,31,127,31,127,30,127,29,127,28,3,31,3,30,113,31,113,30,162,31,193,31,183,31,183,30,183,29,19,31,134,31,4,31,34,31,34,30,141,31,46,31,46,30,2,31,253,31,25,31,233,31,233,30,103,31,57,31);

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
