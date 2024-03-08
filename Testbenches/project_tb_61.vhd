-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_61 is
end project_tb_61;

architecture project_tb_arch_61 of project_tb_61 is
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

constant SCENARIO_LENGTH : integer := 478;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (200,0,0,0,72,0,208,0,35,0,33,0,0,0,248,0,98,0,228,0,0,0,0,0,245,0,0,0,107,0,184,0,133,0,0,0,0,0,245,0,148,0,179,0,243,0,133,0,159,0,179,0,115,0,0,0,21,0,179,0,0,0,0,0,254,0,85,0,248,0,227,0,0,0,74,0,119,0,88,0,251,0,179,0,0,0,153,0,130,0,0,0,179,0,7,0,82,0,68,0,130,0,82,0,40,0,117,0,191,0,79,0,56,0,194,0,106,0,47,0,201,0,147,0,182,0,176,0,0,0,0,0,249,0,139,0,106,0,34,0,146,0,0,0,214,0,0,0,12,0,1,0,0,0,103,0,125,0,0,0,0,0,178,0,231,0,0,0,0,0,208,0,243,0,36,0,105,0,0,0,250,0,0,0,0,0,137,0,0,0,228,0,161,0,234,0,50,0,242,0,0,0,49,0,102,0,24,0,63,0,0,0,0,0,230,0,0,0,141,0,0,0,115,0,16,0,7,0,0,0,0,0,0,0,107,0,151,0,188,0,138,0,52,0,70,0,0,0,111,0,0,0,73,0,160,0,206,0,205,0,195,0,246,0,187,0,226,0,90,0,53,0,114,0,56,0,78,0,132,0,131,0,0,0,163,0,0,0,67,0,196,0,0,0,187,0,99,0,0,0,133,0,228,0,211,0,147,0,244,0,0,0,138,0,158,0,0,0,0,0,251,0,120,0,149,0,92,0,112,0,0,0,0,0,55,0,176,0,0,0,0,0,20,0,0,0,0,0,140,0,85,0,0,0,253,0,0,0,239,0,204,0,95,0,241,0,0,0,1,0,50,0,215,0,146,0,171,0,197,0,241,0,210,0,146,0,51,0,76,0,233,0,65,0,78,0,167,0,188,0,143,0,0,0,175,0,0,0,3,0,140,0,104,0,100,0,170,0,115,0,12,0,115,0,228,0,78,0,0,0,224,0,179,0,185,0,0,0,244,0,102,0,35,0,152,0,67,0,74,0,91,0,235,0,104,0,52,0,227,0,175,0,146,0,205,0,65,0,75,0,127,0,0,0,0,0,75,0,0,0,225,0,111,0,180,0,105,0,0,0,92,0,157,0,0,0,57,0,0,0,0,0,36,0,177,0,0,0,117,0,53,0,109,0,16,0,24,0,228,0,191,0,67,0,200,0,91,0,115,0,13,0,11,0,166,0,66,0,114,0,30,0,66,0,220,0,130,0,244,0,231,0,113,0,1,0,9,0,8,0,48,0,246,0,94,0,0,0,24,0,0,0,0,0,252,0,167,0,147,0,244,0,235,0,67,0,243,0,184,0,161,0,83,0,244,0,129,0,48,0,195,0,8,0,0,0,16,0,132,0,127,0,27,0,97,0,32,0,223,0,248,0,163,0,113,0,223,0,151,0,151,0,187,0,0,0,219,0,91,0,0,0,179,0,61,0,0,0,69,0,0,0,25,0,125,0,25,0,246,0,203,0,24,0,0,0,92,0,215,0,178,0,224,0,81,0,0,0,247,0,211,0,236,0,240,0,230,0,218,0,212,0,0,0,155,0,26,0,106,0,147,0,94,0,149,0,120,0,90,0,223,0,0,0,0,0,25,0,0,0,0,0,166,0,143,0,0,0,3,0,79,0,46,0,79,0,180,0,108,0,111,0,146,0,0,0,146,0,185,0,138,0,94,0,0,0,143,0,0,0,0,0,216,0,194,0,0,0,165,0,13,0,231,0,98,0,187,0,0,0,0,0,0,0,42,0,123,0,110,0,193,0,0,0,202,0,141,0,200,0,187,0,0,0,110,0,0,0,70,0,0,0,7,0,0,0,65,0,0,0,0,0,188,0,163,0,0,0,0,0,242,0,48,0,119,0,33,0,0,0,195,0,0,0,22,0,206,0,0,0,13,0,0,0,194,0,0,0,207,0,29,0,207,0,0,0,200,0,149,0,0,0,26,0,136,0,195,0,0,0,232,0,239,0,169,0,148,0,82,0,0,0,0,0,14,0,211,0,235,0,106,0,73,0,227,0,224,0,147,0,0,0,253,0,0,0,47,0,205,0,106,0,0,0,126,0,194,0,0,0,99,0,0,0,209,0,54,0,227,0,241,0,219,0,0,0,102,0,144,0,74,0,198,0,6,0);
signal scenario_full  : scenario_type := (200,31,200,30,72,31,208,31,35,31,33,31,33,30,248,31,98,31,228,31,228,30,228,29,245,31,245,30,107,31,184,31,133,31,133,30,133,29,245,31,148,31,179,31,243,31,133,31,159,31,179,31,115,31,115,30,21,31,179,31,179,30,179,29,254,31,85,31,248,31,227,31,227,30,74,31,119,31,88,31,251,31,179,31,179,30,153,31,130,31,130,30,179,31,7,31,82,31,68,31,130,31,82,31,40,31,117,31,191,31,79,31,56,31,194,31,106,31,47,31,201,31,147,31,182,31,176,31,176,30,176,29,249,31,139,31,106,31,34,31,146,31,146,30,214,31,214,30,12,31,1,31,1,30,103,31,125,31,125,30,125,29,178,31,231,31,231,30,231,29,208,31,243,31,36,31,105,31,105,30,250,31,250,30,250,29,137,31,137,30,228,31,161,31,234,31,50,31,242,31,242,30,49,31,102,31,24,31,63,31,63,30,63,29,230,31,230,30,141,31,141,30,115,31,16,31,7,31,7,30,7,29,7,28,107,31,151,31,188,31,138,31,52,31,70,31,70,30,111,31,111,30,73,31,160,31,206,31,205,31,195,31,246,31,187,31,226,31,90,31,53,31,114,31,56,31,78,31,132,31,131,31,131,30,163,31,163,30,67,31,196,31,196,30,187,31,99,31,99,30,133,31,228,31,211,31,147,31,244,31,244,30,138,31,158,31,158,30,158,29,251,31,120,31,149,31,92,31,112,31,112,30,112,29,55,31,176,31,176,30,176,29,20,31,20,30,20,29,140,31,85,31,85,30,253,31,253,30,239,31,204,31,95,31,241,31,241,30,1,31,50,31,215,31,146,31,171,31,197,31,241,31,210,31,146,31,51,31,76,31,233,31,65,31,78,31,167,31,188,31,143,31,143,30,175,31,175,30,3,31,140,31,104,31,100,31,170,31,115,31,12,31,115,31,228,31,78,31,78,30,224,31,179,31,185,31,185,30,244,31,102,31,35,31,152,31,67,31,74,31,91,31,235,31,104,31,52,31,227,31,175,31,146,31,205,31,65,31,75,31,127,31,127,30,127,29,75,31,75,30,225,31,111,31,180,31,105,31,105,30,92,31,157,31,157,30,57,31,57,30,57,29,36,31,177,31,177,30,117,31,53,31,109,31,16,31,24,31,228,31,191,31,67,31,200,31,91,31,115,31,13,31,11,31,166,31,66,31,114,31,30,31,66,31,220,31,130,31,244,31,231,31,113,31,1,31,9,31,8,31,48,31,246,31,94,31,94,30,24,31,24,30,24,29,252,31,167,31,147,31,244,31,235,31,67,31,243,31,184,31,161,31,83,31,244,31,129,31,48,31,195,31,8,31,8,30,16,31,132,31,127,31,27,31,97,31,32,31,223,31,248,31,163,31,113,31,223,31,151,31,151,31,187,31,187,30,219,31,91,31,91,30,179,31,61,31,61,30,69,31,69,30,25,31,125,31,25,31,246,31,203,31,24,31,24,30,92,31,215,31,178,31,224,31,81,31,81,30,247,31,211,31,236,31,240,31,230,31,218,31,212,31,212,30,155,31,26,31,106,31,147,31,94,31,149,31,120,31,90,31,223,31,223,30,223,29,25,31,25,30,25,29,166,31,143,31,143,30,3,31,79,31,46,31,79,31,180,31,108,31,111,31,146,31,146,30,146,31,185,31,138,31,94,31,94,30,143,31,143,30,143,29,216,31,194,31,194,30,165,31,13,31,231,31,98,31,187,31,187,30,187,29,187,28,42,31,123,31,110,31,193,31,193,30,202,31,141,31,200,31,187,31,187,30,110,31,110,30,70,31,70,30,7,31,7,30,65,31,65,30,65,29,188,31,163,31,163,30,163,29,242,31,48,31,119,31,33,31,33,30,195,31,195,30,22,31,206,31,206,30,13,31,13,30,194,31,194,30,207,31,29,31,207,31,207,30,200,31,149,31,149,30,26,31,136,31,195,31,195,30,232,31,239,31,169,31,148,31,82,31,82,30,82,29,14,31,211,31,235,31,106,31,73,31,227,31,224,31,147,31,147,30,253,31,253,30,47,31,205,31,106,31,106,30,126,31,194,31,194,30,99,31,99,30,209,31,54,31,227,31,241,31,219,31,219,30,102,31,144,31,74,31,198,31,6,31);

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
