-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_307 is
end project_tb_307;

architecture project_tb_arch_307 of project_tb_307 is
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

constant SCENARIO_LENGTH : integer := 726;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,120,0,26,0,64,0,4,0,170,0,4,0,0,0,66,0,248,0,116,0,31,0,173,0,95,0,98,0,0,0,228,0,141,0,220,0,178,0,177,0,245,0,0,0,236,0,163,0,198,0,67,0,129,0,10,0,204,0,222,0,86,0,217,0,91,0,151,0,0,0,0,0,10,0,0,0,0,0,114,0,20,0,66,0,51,0,79,0,83,0,125,0,226,0,115,0,0,0,37,0,242,0,206,0,1,0,192,0,173,0,206,0,137,0,194,0,0,0,195,0,199,0,187,0,51,0,165,0,0,0,107,0,0,0,232,0,0,0,127,0,31,0,63,0,195,0,78,0,109,0,58,0,181,0,255,0,0,0,75,0,0,0,0,0,208,0,92,0,0,0,0,0,133,0,90,0,222,0,134,0,114,0,0,0,196,0,0,0,253,0,64,0,129,0,135,0,0,0,28,0,16,0,97,0,139,0,111,0,10,0,57,0,117,0,237,0,112,0,33,0,206,0,56,0,0,0,119,0,224,0,117,0,30,0,182,0,148,0,94,0,113,0,244,0,0,0,136,0,145,0,0,0,15,0,117,0,217,0,47,0,20,0,211,0,49,0,37,0,196,0,0,0,199,0,72,0,0,0,132,0,91,0,0,0,173,0,0,0,0,0,46,0,68,0,31,0,76,0,43,0,0,0,0,0,0,0,100,0,210,0,0,0,40,0,29,0,0,0,0,0,77,0,248,0,210,0,226,0,234,0,5,0,0,0,106,0,218,0,0,0,125,0,79,0,223,0,149,0,0,0,168,0,74,0,188,0,240,0,186,0,232,0,238,0,170,0,199,0,61,0,235,0,143,0,103,0,0,0,100,0,202,0,15,0,85,0,40,0,162,0,0,0,83,0,0,0,233,0,50,0,240,0,126,0,237,0,96,0,134,0,202,0,171,0,201,0,0,0,81,0,111,0,100,0,100,0,38,0,0,0,203,0,119,0,73,0,0,0,145,0,9,0,244,0,55,0,163,0,104,0,225,0,21,0,64,0,110,0,165,0,94,0,28,0,86,0,0,0,242,0,38,0,184,0,72,0,0,0,65,0,39,0,192,0,206,0,12,0,132,0,0,0,127,0,30,0,0,0,206,0,208,0,139,0,186,0,36,0,30,0,205,0,0,0,170,0,0,0,196,0,148,0,136,0,204,0,0,0,99,0,238,0,211,0,64,0,0,0,205,0,242,0,77,0,147,0,221,0,34,0,207,0,7,0,0,0,136,0,243,0,0,0,0,0,167,0,202,0,0,0,0,0,236,0,229,0,213,0,0,0,168,0,0,0,214,0,62,0,151,0,159,0,55,0,48,0,0,0,175,0,213,0,62,0,60,0,97,0,68,0,143,0,0,0,207,0,89,0,64,0,121,0,0,0,93,0,205,0,82,0,37,0,219,0,0,0,163,0,52,0,0,0,147,0,0,0,110,0,106,0,0,0,69,0,202,0,225,0,176,0,0,0,0,0,0,0,58,0,249,0,132,0,118,0,151,0,0,0,102,0,0,0,19,0,0,0,0,0,0,0,55,0,194,0,215,0,229,0,16,0,237,0,0,0,0,0,100,0,95,0,44,0,151,0,166,0,67,0,145,0,0,0,66,0,0,0,199,0,0,0,254,0,45,0,54,0,61,0,185,0,110,0,0,0,83,0,69,0,203,0,148,0,154,0,34,0,95,0,0,0,221,0,10,0,0,0,49,0,0,0,206,0,83,0,65,0,74,0,16,0,0,0,0,0,212,0,65,0,74,0,231,0,176,0,0,0,82,0,30,0,136,0,167,0,66,0,188,0,20,0,169,0,74,0,0,0,89,0,0,0,81,0,59,0,150,0,76,0,216,0,27,0,55,0,76,0,197,0,39,0,86,0,82,0,0,0,0,0,195,0,72,0,0,0,0,0,0,0,0,0,128,0,131,0,73,0,206,0,0,0,126,0,0,0,139,0,126,0,207,0,154,0,49,0,217,0,184,0,0,0,186,0,105,0,146,0,143,0,85,0,38,0,0,0,0,0,19,0,250,0,0,0,121,0,115,0,229,0,155,0,63,0,124,0,123,0,133,0,0,0,65,0,249,0,0,0,161,0,0,0,90,0,20,0,199,0,54,0,203,0,177,0,92,0,249,0,63,0,106,0,242,0,180,0,157,0,241,0,74,0,186,0,0,0,247,0,28,0,91,0,18,0,0,0,0,0,20,0,137,0,52,0,146,0,202,0,163,0,156,0,245,0,11,0,175,0,0,0,152,0,232,0,149,0,192,0,0,0,0,0,234,0,0,0,101,0,166,0,144,0,171,0,0,0,10,0,0,0,0,0,12,0,0,0,219,0,10,0,37,0,60,0,104,0,12,0,49,0,170,0,27,0,48,0,49,0,190,0,251,0,203,0,69,0,0,0,0,0,0,0,76,0,214,0,174,0,137,0,55,0,20,0,103,0,103,0,181,0,206,0,0,0,99,0,79,0,252,0,60,0,130,0,0,0,100,0,167,0,14,0,179,0,226,0,158,0,5,0,0,0,29,0,59,0,45,0,190,0,166,0,124,0,183,0,0,0,90,0,209,0,99,0,0,0,99,0,137,0,0,0,166,0,134,0,237,0,86,0,212,0,84,0,0,0,214,0,33,0,246,0,0,0,172,0,166,0,248,0,253,0,234,0,0,0,236,0,219,0,140,0,220,0,204,0,85,0,92,0,23,0,55,0,230,0,0,0,253,0,80,0,27,0,208,0,0,0,203,0,0,0,0,0,59,0,24,0,147,0,0,0,33,0,7,0,68,0,67,0,63,0,0,0,0,0,29,0,0,0,0,0,0,0,202,0,223,0,0,0,179,0,97,0,252,0,236,0,180,0,0,0,0,0,0,0,7,0,10,0,0,0,0,0,72,0,20,0,74,0,156,0,37,0,15,0,233,0,247,0,26,0,75,0,185,0,4,0,31,0,155,0,9,0,221,0,23,0,153,0,175,0,227,0,188,0,185,0,0,0,150,0,115,0,36,0,86,0,51,0,229,0,51,0,240,0,189,0,204,0,46,0,0,0,252,0,133,0,211,0,214,0,0,0,151,0,188,0,71,0,31,0,226,0,0,0,180,0,0,0,109,0,0,0,123,0,95,0,252,0,125,0,245,0,110,0,236,0,52,0,195,0,5,0,147,0,149,0,122,0,82,0,238,0,228,0,198,0,33,0,16,0,50,0,69,0,163,0,228,0,0,0,199,0,41,0,195,0,37,0,41,0);
signal scenario_full  : scenario_type := (0,0,120,31,26,31,64,31,4,31,170,31,4,31,4,30,66,31,248,31,116,31,31,31,173,31,95,31,98,31,98,30,228,31,141,31,220,31,178,31,177,31,245,31,245,30,236,31,163,31,198,31,67,31,129,31,10,31,204,31,222,31,86,31,217,31,91,31,151,31,151,30,151,29,10,31,10,30,10,29,114,31,20,31,66,31,51,31,79,31,83,31,125,31,226,31,115,31,115,30,37,31,242,31,206,31,1,31,192,31,173,31,206,31,137,31,194,31,194,30,195,31,199,31,187,31,51,31,165,31,165,30,107,31,107,30,232,31,232,30,127,31,31,31,63,31,195,31,78,31,109,31,58,31,181,31,255,31,255,30,75,31,75,30,75,29,208,31,92,31,92,30,92,29,133,31,90,31,222,31,134,31,114,31,114,30,196,31,196,30,253,31,64,31,129,31,135,31,135,30,28,31,16,31,97,31,139,31,111,31,10,31,57,31,117,31,237,31,112,31,33,31,206,31,56,31,56,30,119,31,224,31,117,31,30,31,182,31,148,31,94,31,113,31,244,31,244,30,136,31,145,31,145,30,15,31,117,31,217,31,47,31,20,31,211,31,49,31,37,31,196,31,196,30,199,31,72,31,72,30,132,31,91,31,91,30,173,31,173,30,173,29,46,31,68,31,31,31,76,31,43,31,43,30,43,29,43,28,100,31,210,31,210,30,40,31,29,31,29,30,29,29,77,31,248,31,210,31,226,31,234,31,5,31,5,30,106,31,218,31,218,30,125,31,79,31,223,31,149,31,149,30,168,31,74,31,188,31,240,31,186,31,232,31,238,31,170,31,199,31,61,31,235,31,143,31,103,31,103,30,100,31,202,31,15,31,85,31,40,31,162,31,162,30,83,31,83,30,233,31,50,31,240,31,126,31,237,31,96,31,134,31,202,31,171,31,201,31,201,30,81,31,111,31,100,31,100,31,38,31,38,30,203,31,119,31,73,31,73,30,145,31,9,31,244,31,55,31,163,31,104,31,225,31,21,31,64,31,110,31,165,31,94,31,28,31,86,31,86,30,242,31,38,31,184,31,72,31,72,30,65,31,39,31,192,31,206,31,12,31,132,31,132,30,127,31,30,31,30,30,206,31,208,31,139,31,186,31,36,31,30,31,205,31,205,30,170,31,170,30,196,31,148,31,136,31,204,31,204,30,99,31,238,31,211,31,64,31,64,30,205,31,242,31,77,31,147,31,221,31,34,31,207,31,7,31,7,30,136,31,243,31,243,30,243,29,167,31,202,31,202,30,202,29,236,31,229,31,213,31,213,30,168,31,168,30,214,31,62,31,151,31,159,31,55,31,48,31,48,30,175,31,213,31,62,31,60,31,97,31,68,31,143,31,143,30,207,31,89,31,64,31,121,31,121,30,93,31,205,31,82,31,37,31,219,31,219,30,163,31,52,31,52,30,147,31,147,30,110,31,106,31,106,30,69,31,202,31,225,31,176,31,176,30,176,29,176,28,58,31,249,31,132,31,118,31,151,31,151,30,102,31,102,30,19,31,19,30,19,29,19,28,55,31,194,31,215,31,229,31,16,31,237,31,237,30,237,29,100,31,95,31,44,31,151,31,166,31,67,31,145,31,145,30,66,31,66,30,199,31,199,30,254,31,45,31,54,31,61,31,185,31,110,31,110,30,83,31,69,31,203,31,148,31,154,31,34,31,95,31,95,30,221,31,10,31,10,30,49,31,49,30,206,31,83,31,65,31,74,31,16,31,16,30,16,29,212,31,65,31,74,31,231,31,176,31,176,30,82,31,30,31,136,31,167,31,66,31,188,31,20,31,169,31,74,31,74,30,89,31,89,30,81,31,59,31,150,31,76,31,216,31,27,31,55,31,76,31,197,31,39,31,86,31,82,31,82,30,82,29,195,31,72,31,72,30,72,29,72,28,72,27,128,31,131,31,73,31,206,31,206,30,126,31,126,30,139,31,126,31,207,31,154,31,49,31,217,31,184,31,184,30,186,31,105,31,146,31,143,31,85,31,38,31,38,30,38,29,19,31,250,31,250,30,121,31,115,31,229,31,155,31,63,31,124,31,123,31,133,31,133,30,65,31,249,31,249,30,161,31,161,30,90,31,20,31,199,31,54,31,203,31,177,31,92,31,249,31,63,31,106,31,242,31,180,31,157,31,241,31,74,31,186,31,186,30,247,31,28,31,91,31,18,31,18,30,18,29,20,31,137,31,52,31,146,31,202,31,163,31,156,31,245,31,11,31,175,31,175,30,152,31,232,31,149,31,192,31,192,30,192,29,234,31,234,30,101,31,166,31,144,31,171,31,171,30,10,31,10,30,10,29,12,31,12,30,219,31,10,31,37,31,60,31,104,31,12,31,49,31,170,31,27,31,48,31,49,31,190,31,251,31,203,31,69,31,69,30,69,29,69,28,76,31,214,31,174,31,137,31,55,31,20,31,103,31,103,31,181,31,206,31,206,30,99,31,79,31,252,31,60,31,130,31,130,30,100,31,167,31,14,31,179,31,226,31,158,31,5,31,5,30,29,31,59,31,45,31,190,31,166,31,124,31,183,31,183,30,90,31,209,31,99,31,99,30,99,31,137,31,137,30,166,31,134,31,237,31,86,31,212,31,84,31,84,30,214,31,33,31,246,31,246,30,172,31,166,31,248,31,253,31,234,31,234,30,236,31,219,31,140,31,220,31,204,31,85,31,92,31,23,31,55,31,230,31,230,30,253,31,80,31,27,31,208,31,208,30,203,31,203,30,203,29,59,31,24,31,147,31,147,30,33,31,7,31,68,31,67,31,63,31,63,30,63,29,29,31,29,30,29,29,29,28,202,31,223,31,223,30,179,31,97,31,252,31,236,31,180,31,180,30,180,29,180,28,7,31,10,31,10,30,10,29,72,31,20,31,74,31,156,31,37,31,15,31,233,31,247,31,26,31,75,31,185,31,4,31,31,31,155,31,9,31,221,31,23,31,153,31,175,31,227,31,188,31,185,31,185,30,150,31,115,31,36,31,86,31,51,31,229,31,51,31,240,31,189,31,204,31,46,31,46,30,252,31,133,31,211,31,214,31,214,30,151,31,188,31,71,31,31,31,226,31,226,30,180,31,180,30,109,31,109,30,123,31,95,31,252,31,125,31,245,31,110,31,236,31,52,31,195,31,5,31,147,31,149,31,122,31,82,31,238,31,228,31,198,31,33,31,16,31,50,31,69,31,163,31,228,31,228,30,199,31,41,31,195,31,37,31,41,31);

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
