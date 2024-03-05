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

constant SCENARIO_LENGTH : integer := 618;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (122,0,161,0,114,0,204,0,193,0,0,0,54,0,214,0,252,0,212,0,139,0,0,0,107,0,62,0,0,0,0,0,150,0,0,0,38,0,227,0,122,0,209,0,234,0,243,0,213,0,53,0,165,0,46,0,0,0,171,0,213,0,202,0,2,0,92,0,156,0,229,0,102,0,135,0,239,0,71,0,165,0,235,0,55,0,195,0,234,0,97,0,43,0,15,0,217,0,55,0,91,0,31,0,0,0,0,0,164,0,3,0,175,0,155,0,35,0,210,0,87,0,134,0,155,0,189,0,142,0,164,0,122,0,96,0,41,0,108,0,76,0,103,0,104,0,81,0,207,0,199,0,70,0,220,0,247,0,0,0,86,0,0,0,145,0,164,0,0,0,147,0,125,0,164,0,253,0,118,0,196,0,188,0,0,0,0,0,6,0,76,0,43,0,104,0,93,0,237,0,48,0,98,0,0,0,141,0,168,0,0,0,237,0,0,0,57,0,150,0,121,0,0,0,156,0,228,0,46,0,130,0,241,0,247,0,171,0,106,0,69,0,239,0,171,0,68,0,132,0,148,0,83,0,82,0,224,0,0,0,196,0,113,0,119,0,181,0,138,0,151,0,96,0,248,0,201,0,28,0,0,0,31,0,75,0,0,0,178,0,106,0,16,0,16,0,0,0,0,0,180,0,249,0,92,0,97,0,36,0,239,0,70,0,135,0,164,0,220,0,250,0,86,0,82,0,137,0,0,0,118,0,26,0,138,0,78,0,142,0,0,0,89,0,207,0,18,0,150,0,244,0,0,0,0,0,34,0,0,0,0,0,8,0,0,0,23,0,0,0,65,0,0,0,27,0,0,0,0,0,233,0,212,0,180,0,162,0,0,0,0,0,95,0,118,0,0,0,0,0,181,0,0,0,124,0,0,0,190,0,252,0,108,0,130,0,217,0,156,0,103,0,138,0,0,0,136,0,53,0,0,0,13,0,136,0,35,0,92,0,177,0,102,0,39,0,31,0,43,0,21,0,222,0,122,0,33,0,237,0,9,0,36,0,205,0,0,0,183,0,0,0,0,0,144,0,65,0,216,0,75,0,186,0,181,0,244,0,166,0,9,0,17,0,108,0,221,0,173,0,157,0,243,0,91,0,238,0,236,0,0,0,72,0,35,0,80,0,216,0,48,0,246,0,34,0,14,0,91,0,0,0,215,0,124,0,100,0,165,0,0,0,239,0,0,0,0,0,223,0,105,0,43,0,194,0,45,0,86,0,0,0,0,0,86,0,0,0,196,0,0,0,184,0,95,0,189,0,213,0,238,0,90,0,168,0,209,0,138,0,11,0,66,0,236,0,105,0,0,0,193,0,46,0,10,0,0,0,73,0,0,0,146,0,53,0,248,0,198,0,2,0,179,0,0,0,26,0,76,0,122,0,55,0,0,0,129,0,14,0,62,0,202,0,195,0,78,0,0,0,254,0,61,0,236,0,66,0,71,0,137,0,171,0,76,0,0,0,0,0,114,0,240,0,196,0,19,0,45,0,117,0,180,0,232,0,80,0,200,0,110,0,35,0,0,0,122,0,39,0,231,0,18,0,0,0,148,0,158,0,181,0,0,0,60,0,45,0,0,0,226,0,210,0,25,0,0,0,54,0,160,0,74,0,0,0,0,0,239,0,135,0,235,0,135,0,251,0,224,0,63,0,139,0,130,0,90,0,0,0,235,0,131,0,31,0,0,0,229,0,0,0,101,0,0,0,0,0,0,0,221,0,246,0,0,0,232,0,144,0,224,0,0,0,0,0,15,0,72,0,241,0,0,0,146,0,0,0,0,0,82,0,19,0,123,0,193,0,0,0,0,0,195,0,219,0,49,0,255,0,4,0,116,0,77,0,142,0,0,0,91,0,117,0,145,0,208,0,56,0,28,0,175,0,61,0,0,0,61,0,27,0,87,0,189,0,130,0,238,0,132,0,191,0,237,0,203,0,0,0,0,0,0,0,103,0,247,0,35,0,134,0,25,0,135,0,19,0,97,0,16,0,111,0,215,0,151,0,0,0,250,0,143,0,209,0,26,0,166,0,82,0,167,0,124,0,105,0,150,0,19,0,217,0,0,0,239,0,131,0,42,0,173,0,0,0,101,0,198,0,22,0,0,0,182,0,180,0,22,0,0,0,0,0,175,0,192,0,71,0,0,0,30,0,0,0,175,0,150,0,160,0,0,0,154,0,104,0,160,0,199,0,198,0,36,0,247,0,209,0,69,0,0,0,0,0,218,0,157,0,121,0,153,0,91,0,0,0,87,0,101,0,0,0,0,0,82,0,168,0,74,0,0,0,194,0,0,0,0,0,206,0,5,0,53,0,179,0,172,0,98,0,0,0,246,0,0,0,251,0,231,0,0,0,0,0,223,0,141,0,189,0,0,0,221,0,241,0,64,0,107,0,40,0,5,0,53,0,0,0,55,0,21,0,65,0,0,0,139,0,88,0,32,0,217,0,98,0,79,0,204,0,254,0,100,0,225,0,0,0,119,0,216,0,77,0,34,0,108,0,176,0,117,0,51,0,237,0,72,0,4,0,106,0,0,0,211,0,244,0,0,0,146,0,0,0,133,0,184,0,240,0,46,0,155,0,116,0,154,0,239,0,219,0,130,0,174,0,0,0,0,0,118,0,0,0,195,0,75,0,68,0,194,0,255,0,0,0,0,0,0,0,113,0,43,0,67,0,213,0,218,0,232,0,0,0,94,0,0,0,0,0,0,0,0,0,77,0,246,0,49,0,54,0,242,0);
signal scenario_full  : scenario_type := (122,31,161,31,114,31,204,31,193,31,193,30,54,31,214,31,252,31,212,31,139,31,139,30,107,31,62,31,62,30,62,29,150,31,150,30,38,31,227,31,122,31,209,31,234,31,243,31,213,31,53,31,165,31,46,31,46,30,171,31,213,31,202,31,2,31,92,31,156,31,229,31,102,31,135,31,239,31,71,31,165,31,235,31,55,31,195,31,234,31,97,31,43,31,15,31,217,31,55,31,91,31,31,31,31,30,31,29,164,31,3,31,175,31,155,31,35,31,210,31,87,31,134,31,155,31,189,31,142,31,164,31,122,31,96,31,41,31,108,31,76,31,103,31,104,31,81,31,207,31,199,31,70,31,220,31,247,31,247,30,86,31,86,30,145,31,164,31,164,30,147,31,125,31,164,31,253,31,118,31,196,31,188,31,188,30,188,29,6,31,76,31,43,31,104,31,93,31,237,31,48,31,98,31,98,30,141,31,168,31,168,30,237,31,237,30,57,31,150,31,121,31,121,30,156,31,228,31,46,31,130,31,241,31,247,31,171,31,106,31,69,31,239,31,171,31,68,31,132,31,148,31,83,31,82,31,224,31,224,30,196,31,113,31,119,31,181,31,138,31,151,31,96,31,248,31,201,31,28,31,28,30,31,31,75,31,75,30,178,31,106,31,16,31,16,31,16,30,16,29,180,31,249,31,92,31,97,31,36,31,239,31,70,31,135,31,164,31,220,31,250,31,86,31,82,31,137,31,137,30,118,31,26,31,138,31,78,31,142,31,142,30,89,31,207,31,18,31,150,31,244,31,244,30,244,29,34,31,34,30,34,29,8,31,8,30,23,31,23,30,65,31,65,30,27,31,27,30,27,29,233,31,212,31,180,31,162,31,162,30,162,29,95,31,118,31,118,30,118,29,181,31,181,30,124,31,124,30,190,31,252,31,108,31,130,31,217,31,156,31,103,31,138,31,138,30,136,31,53,31,53,30,13,31,136,31,35,31,92,31,177,31,102,31,39,31,31,31,43,31,21,31,222,31,122,31,33,31,237,31,9,31,36,31,205,31,205,30,183,31,183,30,183,29,144,31,65,31,216,31,75,31,186,31,181,31,244,31,166,31,9,31,17,31,108,31,221,31,173,31,157,31,243,31,91,31,238,31,236,31,236,30,72,31,35,31,80,31,216,31,48,31,246,31,34,31,14,31,91,31,91,30,215,31,124,31,100,31,165,31,165,30,239,31,239,30,239,29,223,31,105,31,43,31,194,31,45,31,86,31,86,30,86,29,86,31,86,30,196,31,196,30,184,31,95,31,189,31,213,31,238,31,90,31,168,31,209,31,138,31,11,31,66,31,236,31,105,31,105,30,193,31,46,31,10,31,10,30,73,31,73,30,146,31,53,31,248,31,198,31,2,31,179,31,179,30,26,31,76,31,122,31,55,31,55,30,129,31,14,31,62,31,202,31,195,31,78,31,78,30,254,31,61,31,236,31,66,31,71,31,137,31,171,31,76,31,76,30,76,29,114,31,240,31,196,31,19,31,45,31,117,31,180,31,232,31,80,31,200,31,110,31,35,31,35,30,122,31,39,31,231,31,18,31,18,30,148,31,158,31,181,31,181,30,60,31,45,31,45,30,226,31,210,31,25,31,25,30,54,31,160,31,74,31,74,30,74,29,239,31,135,31,235,31,135,31,251,31,224,31,63,31,139,31,130,31,90,31,90,30,235,31,131,31,31,31,31,30,229,31,229,30,101,31,101,30,101,29,101,28,221,31,246,31,246,30,232,31,144,31,224,31,224,30,224,29,15,31,72,31,241,31,241,30,146,31,146,30,146,29,82,31,19,31,123,31,193,31,193,30,193,29,195,31,219,31,49,31,255,31,4,31,116,31,77,31,142,31,142,30,91,31,117,31,145,31,208,31,56,31,28,31,175,31,61,31,61,30,61,31,27,31,87,31,189,31,130,31,238,31,132,31,191,31,237,31,203,31,203,30,203,29,203,28,103,31,247,31,35,31,134,31,25,31,135,31,19,31,97,31,16,31,111,31,215,31,151,31,151,30,250,31,143,31,209,31,26,31,166,31,82,31,167,31,124,31,105,31,150,31,19,31,217,31,217,30,239,31,131,31,42,31,173,31,173,30,101,31,198,31,22,31,22,30,182,31,180,31,22,31,22,30,22,29,175,31,192,31,71,31,71,30,30,31,30,30,175,31,150,31,160,31,160,30,154,31,104,31,160,31,199,31,198,31,36,31,247,31,209,31,69,31,69,30,69,29,218,31,157,31,121,31,153,31,91,31,91,30,87,31,101,31,101,30,101,29,82,31,168,31,74,31,74,30,194,31,194,30,194,29,206,31,5,31,53,31,179,31,172,31,98,31,98,30,246,31,246,30,251,31,231,31,231,30,231,29,223,31,141,31,189,31,189,30,221,31,241,31,64,31,107,31,40,31,5,31,53,31,53,30,55,31,21,31,65,31,65,30,139,31,88,31,32,31,217,31,98,31,79,31,204,31,254,31,100,31,225,31,225,30,119,31,216,31,77,31,34,31,108,31,176,31,117,31,51,31,237,31,72,31,4,31,106,31,106,30,211,31,244,31,244,30,146,31,146,30,133,31,184,31,240,31,46,31,155,31,116,31,154,31,239,31,219,31,130,31,174,31,174,30,174,29,118,31,118,30,195,31,75,31,68,31,194,31,255,31,255,30,255,29,255,28,113,31,43,31,67,31,213,31,218,31,232,31,232,30,94,31,94,30,94,29,94,28,94,27,77,31,246,31,49,31,54,31,242,31);

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
