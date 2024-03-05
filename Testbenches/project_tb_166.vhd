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

constant SCENARIO_LENGTH : integer := 440;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (173,0,131,0,159,0,0,0,0,0,141,0,11,0,13,0,211,0,15,0,220,0,40,0,0,0,51,0,198,0,12,0,93,0,0,0,230,0,250,0,199,0,111,0,210,0,62,0,0,0,28,0,184,0,214,0,11,0,199,0,153,0,30,0,234,0,70,0,0,0,35,0,15,0,70,0,63,0,204,0,51,0,210,0,0,0,111,0,206,0,0,0,204,0,0,0,0,0,53,0,82,0,19,0,85,0,56,0,0,0,0,0,220,0,251,0,190,0,57,0,234,0,178,0,162,0,209,0,235,0,118,0,84,0,25,0,68,0,0,0,0,0,55,0,133,0,237,0,122,0,0,0,0,0,172,0,98,0,214,0,172,0,69,0,111,0,0,0,219,0,40,0,190,0,52,0,175,0,0,0,251,0,0,0,163,0,35,0,170,0,139,0,116,0,0,0,188,0,254,0,129,0,0,0,204,0,0,0,58,0,43,0,46,0,51,0,98,0,142,0,126,0,231,0,7,0,0,0,219,0,65,0,28,0,251,0,88,0,5,0,89,0,0,0,38,0,34,0,233,0,109,0,0,0,24,0,196,0,0,0,0,0,46,0,18,0,241,0,110,0,0,0,159,0,119,0,238,0,64,0,20,0,153,0,202,0,99,0,0,0,199,0,109,0,0,0,173,0,0,0,151,0,26,0,85,0,82,0,0,0,0,0,0,0,0,0,105,0,231,0,111,0,99,0,83,0,27,0,203,0,228,0,0,0,0,0,188,0,194,0,191,0,67,0,71,0,58,0,0,0,177,0,138,0,2,0,42,0,2,0,75,0,0,0,0,0,238,0,11,0,0,0,33,0,203,0,74,0,106,0,153,0,214,0,0,0,191,0,70,0,253,0,187,0,80,0,0,0,0,0,0,0,203,0,27,0,207,0,214,0,213,0,16,0,69,0,190,0,203,0,112,0,222,0,27,0,36,0,6,0,223,0,2,0,8,0,142,0,183,0,142,0,182,0,123,0,229,0,233,0,0,0,73,0,162,0,0,0,0,0,147,0,244,0,114,0,0,0,104,0,0,0,0,0,0,0,49,0,125,0,219,0,33,0,213,0,197,0,235,0,188,0,6,0,0,0,106,0,0,0,115,0,0,0,143,0,106,0,7,0,45,0,116,0,45,0,169,0,20,0,28,0,88,0,142,0,222,0,43,0,164,0,193,0,0,0,161,0,7,0,5,0,84,0,162,0,143,0,48,0,138,0,0,0,192,0,245,0,88,0,94,0,235,0,245,0,172,0,250,0,161,0,84,0,124,0,5,0,176,0,150,0,167,0,0,0,79,0,188,0,64,0,76,0,178,0,0,0,183,0,53,0,72,0,191,0,95,0,167,0,228,0,161,0,0,0,97,0,147,0,91,0,111,0,109,0,43,0,0,0,168,0,116,0,9,0,221,0,46,0,70,0,98,0,0,0,2,0,107,0,89,0,0,0,240,0,155,0,0,0,72,0,224,0,144,0,136,0,202,0,99,0,143,0,165,0,146,0,0,0,196,0,0,0,84,0,12,0,164,0,1,0,96,0,200,0,0,0,3,0,187,0,29,0,15,0,224,0,234,0,125,0,95,0,245,0,239,0,0,0,46,0,240,0,114,0,207,0,244,0,92,0,221,0,103,0,14,0,106,0,26,0,159,0,127,0,0,0,188,0,0,0,250,0,55,0,57,0,167,0,0,0,99,0,226,0,38,0,0,0,45,0,66,0,0,0,26,0,177,0,0,0,42,0,0,0,135,0,108,0,0,0,64,0,11,0,206,0,88,0,0,0,157,0,104,0,64,0,0,0,0,0,0,0,0,0,190,0,223,0,198,0,217,0,20,0,120,0,81,0,120,0,137,0,0,0,0,0,248,0,200,0,200,0,216,0,157,0,247,0,199,0,72,0,163,0,165,0,0,0,212,0,141,0,66,0,102,0,19,0,0,0,198,0,0,0,66,0,212,0);
signal scenario_full  : scenario_type := (173,31,131,31,159,31,159,30,159,29,141,31,11,31,13,31,211,31,15,31,220,31,40,31,40,30,51,31,198,31,12,31,93,31,93,30,230,31,250,31,199,31,111,31,210,31,62,31,62,30,28,31,184,31,214,31,11,31,199,31,153,31,30,31,234,31,70,31,70,30,35,31,15,31,70,31,63,31,204,31,51,31,210,31,210,30,111,31,206,31,206,30,204,31,204,30,204,29,53,31,82,31,19,31,85,31,56,31,56,30,56,29,220,31,251,31,190,31,57,31,234,31,178,31,162,31,209,31,235,31,118,31,84,31,25,31,68,31,68,30,68,29,55,31,133,31,237,31,122,31,122,30,122,29,172,31,98,31,214,31,172,31,69,31,111,31,111,30,219,31,40,31,190,31,52,31,175,31,175,30,251,31,251,30,163,31,35,31,170,31,139,31,116,31,116,30,188,31,254,31,129,31,129,30,204,31,204,30,58,31,43,31,46,31,51,31,98,31,142,31,126,31,231,31,7,31,7,30,219,31,65,31,28,31,251,31,88,31,5,31,89,31,89,30,38,31,34,31,233,31,109,31,109,30,24,31,196,31,196,30,196,29,46,31,18,31,241,31,110,31,110,30,159,31,119,31,238,31,64,31,20,31,153,31,202,31,99,31,99,30,199,31,109,31,109,30,173,31,173,30,151,31,26,31,85,31,82,31,82,30,82,29,82,28,82,27,105,31,231,31,111,31,99,31,83,31,27,31,203,31,228,31,228,30,228,29,188,31,194,31,191,31,67,31,71,31,58,31,58,30,177,31,138,31,2,31,42,31,2,31,75,31,75,30,75,29,238,31,11,31,11,30,33,31,203,31,74,31,106,31,153,31,214,31,214,30,191,31,70,31,253,31,187,31,80,31,80,30,80,29,80,28,203,31,27,31,207,31,214,31,213,31,16,31,69,31,190,31,203,31,112,31,222,31,27,31,36,31,6,31,223,31,2,31,8,31,142,31,183,31,142,31,182,31,123,31,229,31,233,31,233,30,73,31,162,31,162,30,162,29,147,31,244,31,114,31,114,30,104,31,104,30,104,29,104,28,49,31,125,31,219,31,33,31,213,31,197,31,235,31,188,31,6,31,6,30,106,31,106,30,115,31,115,30,143,31,106,31,7,31,45,31,116,31,45,31,169,31,20,31,28,31,88,31,142,31,222,31,43,31,164,31,193,31,193,30,161,31,7,31,5,31,84,31,162,31,143,31,48,31,138,31,138,30,192,31,245,31,88,31,94,31,235,31,245,31,172,31,250,31,161,31,84,31,124,31,5,31,176,31,150,31,167,31,167,30,79,31,188,31,64,31,76,31,178,31,178,30,183,31,53,31,72,31,191,31,95,31,167,31,228,31,161,31,161,30,97,31,147,31,91,31,111,31,109,31,43,31,43,30,168,31,116,31,9,31,221,31,46,31,70,31,98,31,98,30,2,31,107,31,89,31,89,30,240,31,155,31,155,30,72,31,224,31,144,31,136,31,202,31,99,31,143,31,165,31,146,31,146,30,196,31,196,30,84,31,12,31,164,31,1,31,96,31,200,31,200,30,3,31,187,31,29,31,15,31,224,31,234,31,125,31,95,31,245,31,239,31,239,30,46,31,240,31,114,31,207,31,244,31,92,31,221,31,103,31,14,31,106,31,26,31,159,31,127,31,127,30,188,31,188,30,250,31,55,31,57,31,167,31,167,30,99,31,226,31,38,31,38,30,45,31,66,31,66,30,26,31,177,31,177,30,42,31,42,30,135,31,108,31,108,30,64,31,11,31,206,31,88,31,88,30,157,31,104,31,64,31,64,30,64,29,64,28,64,27,190,31,223,31,198,31,217,31,20,31,120,31,81,31,120,31,137,31,137,30,137,29,248,31,200,31,200,31,216,31,157,31,247,31,199,31,72,31,163,31,165,31,165,30,212,31,141,31,66,31,102,31,19,31,19,30,198,31,198,30,66,31,212,31);

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
