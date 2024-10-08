-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_699 is
end project_tb_699;

architecture project_tb_arch_699 of project_tb_699 is
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

constant SCENARIO_LENGTH : integer := 739;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (1,0,162,0,126,0,51,0,160,0,9,0,38,0,82,0,0,0,76,0,0,0,77,0,0,0,3,0,43,0,126,0,136,0,114,0,0,0,0,0,52,0,133,0,0,0,46,0,254,0,0,0,75,0,202,0,87,0,169,0,4,0,99,0,30,0,0,0,24,0,124,0,239,0,209,0,172,0,108,0,26,0,212,0,21,0,208,0,129,0,116,0,0,0,3,0,93,0,198,0,52,0,61,0,150,0,47,0,0,0,0,0,18,0,145,0,194,0,0,0,0,0,228,0,144,0,51,0,161,0,180,0,60,0,133,0,0,0,248,0,230,0,84,0,242,0,2,0,255,0,132,0,138,0,0,0,127,0,60,0,214,0,198,0,55,0,159,0,8,0,225,0,0,0,227,0,93,0,162,0,0,0,183,0,36,0,0,0,0,0,164,0,187,0,0,0,73,0,81,0,185,0,164,0,51,0,32,0,249,0,66,0,233,0,97,0,93,0,192,0,201,0,66,0,6,0,82,0,104,0,191,0,0,0,64,0,129,0,120,0,83,0,101,0,151,0,33,0,135,0,0,0,0,0,12,0,0,0,195,0,0,0,217,0,96,0,216,0,224,0,140,0,0,0,0,0,202,0,0,0,85,0,162,0,87,0,0,0,152,0,39,0,0,0,169,0,202,0,150,0,166,0,130,0,165,0,0,0,0,0,167,0,164,0,0,0,20,0,126,0,209,0,131,0,162,0,0,0,223,0,157,0,29,0,48,0,90,0,163,0,33,0,212,0,133,0,29,0,119,0,232,0,0,0,0,0,7,0,236,0,233,0,144,0,93,0,11,0,0,0,139,0,0,0,70,0,0,0,0,0,0,0,125,0,159,0,28,0,87,0,164,0,36,0,111,0,32,0,0,0,72,0,0,0,0,0,120,0,189,0,139,0,0,0,199,0,165,0,203,0,81,0,49,0,0,0,0,0,115,0,166,0,94,0,0,0,0,0,209,0,0,0,0,0,170,0,0,0,239,0,140,0,41,0,248,0,164,0,95,0,137,0,118,0,65,0,0,0,192,0,235,0,218,0,0,0,0,0,0,0,0,0,35,0,0,0,0,0,42,0,15,0,0,0,205,0,101,0,217,0,0,0,0,0,112,0,236,0,216,0,209,0,15,0,201,0,78,0,230,0,29,0,217,0,216,0,0,0,247,0,0,0,236,0,90,0,205,0,105,0,241,0,98,0,87,0,115,0,0,0,240,0,84,0,97,0,95,0,214,0,149,0,84,0,242,0,24,0,0,0,150,0,247,0,50,0,89,0,0,0,158,0,97,0,163,0,0,0,0,0,40,0,179,0,0,0,0,0,0,0,105,0,150,0,194,0,114,0,0,0,0,0,0,0,36,0,0,0,0,0,221,0,33,0,100,0,155,0,94,0,216,0,64,0,8,0,23,0,0,0,161,0,115,0,113,0,212,0,0,0,92,0,0,0,115,0,81,0,0,0,110,0,0,0,246,0,253,0,11,0,28,0,0,0,0,0,0,0,104,0,0,0,0,0,62,0,151,0,118,0,0,0,196,0,208,0,61,0,0,0,0,0,218,0,0,0,216,0,176,0,173,0,99,0,238,0,73,0,50,0,99,0,44,0,6,0,182,0,55,0,0,0,115,0,128,0,51,0,147,0,145,0,26,0,249,0,189,0,41,0,0,0,235,0,21,0,205,0,0,0,160,0,0,0,27,0,144,0,200,0,0,0,0,0,0,0,211,0,97,0,145,0,26,0,90,0,237,0,30,0,182,0,0,0,185,0,144,0,226,0,0,0,60,0,96,0,166,0,114,0,0,0,192,0,144,0,131,0,160,0,204,0,0,0,0,0,226,0,9,0,0,0,118,0,214,0,182,0,27,0,41,0,151,0,107,0,120,0,203,0,50,0,133,0,0,0,0,0,88,0,0,0,144,0,223,0,154,0,49,0,0,0,53,0,0,0,59,0,0,0,128,0,0,0,193,0,206,0,170,0,0,0,74,0,162,0,217,0,0,0,82,0,133,0,24,0,212,0,237,0,255,0,68,0,255,0,0,0,46,0,0,0,49,0,0,0,160,0,0,0,195,0,87,0,68,0,0,0,253,0,136,0,32,0,134,0,0,0,229,0,219,0,217,0,226,0,0,0,0,0,208,0,220,0,58,0,228,0,152,0,206,0,245,0,229,0,142,0,206,0,255,0,23,0,54,0,7,0,12,0,0,0,26,0,7,0,137,0,2,0,222,0,129,0,205,0,226,0,184,0,119,0,226,0,171,0,154,0,0,0,17,0,142,0,130,0,63,0,0,0,0,0,171,0,97,0,249,0,230,0,114,0,0,0,79,0,62,0,0,0,130,0,107,0,226,0,0,0,224,0,46,0,0,0,56,0,0,0,161,0,78,0,199,0,59,0,0,0,9,0,0,0,65,0,0,0,143,0,0,0,85,0,45,0,31,0,145,0,191,0,180,0,48,0,117,0,0,0,0,0,74,0,78,0,90,0,213,0,136,0,0,0,247,0,0,0,0,0,240,0,0,0,0,0,159,0,203,0,2,0,7,0,0,0,41,0,182,0,57,0,176,0,73,0,170,0,0,0,4,0,231,0,233,0,170,0,33,0,165,0,6,0,58,0,182,0,0,0,0,0,98,0,219,0,0,0,0,0,175,0,110,0,2,0,155,0,22,0,106,0,0,0,145,0,73,0,16,0,250,0,100,0,0,0,75,0,19,0,12,0,119,0,34,0,107,0,204,0,132,0,167,0,243,0,0,0,148,0,205,0,197,0,173,0,159,0,35,0,139,0,0,0,109,0,97,0,76,0,0,0,205,0,63,0,0,0,0,0,50,0,0,0,0,0,0,0,255,0,123,0,0,0,159,0,204,0,0,0,0,0,5,0,0,0,182,0,219,0,189,0,204,0,98,0,183,0,53,0,33,0,0,0,224,0,0,0,148,0,74,0,212,0,216,0,155,0,166,0,252,0,0,0,194,0,193,0,0,0,143,0,234,0,124,0,0,0,0,0,147,0,247,0,163,0,154,0,0,0,105,0,0,0,0,0,1,0,200,0,35,0,0,0,36,0,128,0,24,0,0,0,76,0,60,0,0,0,0,0,200,0,231,0,172,0,0,0,164,0,0,0,0,0,48,0,46,0,199,0,0,0,147,0,18,0,52,0,47,0,69,0,131,0,0,0,1,0,0,0,60,0,67,0,0,0,155,0,0,0,74,0,0,0,0,0,46,0,126,0,254,0,135,0,57,0,148,0,24,0,248,0,205,0,56,0,0,0,30,0,18,0,0,0,0,0,231,0,16,0);
signal scenario_full  : scenario_type := (1,31,162,31,126,31,51,31,160,31,9,31,38,31,82,31,82,30,76,31,76,30,77,31,77,30,3,31,43,31,126,31,136,31,114,31,114,30,114,29,52,31,133,31,133,30,46,31,254,31,254,30,75,31,202,31,87,31,169,31,4,31,99,31,30,31,30,30,24,31,124,31,239,31,209,31,172,31,108,31,26,31,212,31,21,31,208,31,129,31,116,31,116,30,3,31,93,31,198,31,52,31,61,31,150,31,47,31,47,30,47,29,18,31,145,31,194,31,194,30,194,29,228,31,144,31,51,31,161,31,180,31,60,31,133,31,133,30,248,31,230,31,84,31,242,31,2,31,255,31,132,31,138,31,138,30,127,31,60,31,214,31,198,31,55,31,159,31,8,31,225,31,225,30,227,31,93,31,162,31,162,30,183,31,36,31,36,30,36,29,164,31,187,31,187,30,73,31,81,31,185,31,164,31,51,31,32,31,249,31,66,31,233,31,97,31,93,31,192,31,201,31,66,31,6,31,82,31,104,31,191,31,191,30,64,31,129,31,120,31,83,31,101,31,151,31,33,31,135,31,135,30,135,29,12,31,12,30,195,31,195,30,217,31,96,31,216,31,224,31,140,31,140,30,140,29,202,31,202,30,85,31,162,31,87,31,87,30,152,31,39,31,39,30,169,31,202,31,150,31,166,31,130,31,165,31,165,30,165,29,167,31,164,31,164,30,20,31,126,31,209,31,131,31,162,31,162,30,223,31,157,31,29,31,48,31,90,31,163,31,33,31,212,31,133,31,29,31,119,31,232,31,232,30,232,29,7,31,236,31,233,31,144,31,93,31,11,31,11,30,139,31,139,30,70,31,70,30,70,29,70,28,125,31,159,31,28,31,87,31,164,31,36,31,111,31,32,31,32,30,72,31,72,30,72,29,120,31,189,31,139,31,139,30,199,31,165,31,203,31,81,31,49,31,49,30,49,29,115,31,166,31,94,31,94,30,94,29,209,31,209,30,209,29,170,31,170,30,239,31,140,31,41,31,248,31,164,31,95,31,137,31,118,31,65,31,65,30,192,31,235,31,218,31,218,30,218,29,218,28,218,27,35,31,35,30,35,29,42,31,15,31,15,30,205,31,101,31,217,31,217,30,217,29,112,31,236,31,216,31,209,31,15,31,201,31,78,31,230,31,29,31,217,31,216,31,216,30,247,31,247,30,236,31,90,31,205,31,105,31,241,31,98,31,87,31,115,31,115,30,240,31,84,31,97,31,95,31,214,31,149,31,84,31,242,31,24,31,24,30,150,31,247,31,50,31,89,31,89,30,158,31,97,31,163,31,163,30,163,29,40,31,179,31,179,30,179,29,179,28,105,31,150,31,194,31,114,31,114,30,114,29,114,28,36,31,36,30,36,29,221,31,33,31,100,31,155,31,94,31,216,31,64,31,8,31,23,31,23,30,161,31,115,31,113,31,212,31,212,30,92,31,92,30,115,31,81,31,81,30,110,31,110,30,246,31,253,31,11,31,28,31,28,30,28,29,28,28,104,31,104,30,104,29,62,31,151,31,118,31,118,30,196,31,208,31,61,31,61,30,61,29,218,31,218,30,216,31,176,31,173,31,99,31,238,31,73,31,50,31,99,31,44,31,6,31,182,31,55,31,55,30,115,31,128,31,51,31,147,31,145,31,26,31,249,31,189,31,41,31,41,30,235,31,21,31,205,31,205,30,160,31,160,30,27,31,144,31,200,31,200,30,200,29,200,28,211,31,97,31,145,31,26,31,90,31,237,31,30,31,182,31,182,30,185,31,144,31,226,31,226,30,60,31,96,31,166,31,114,31,114,30,192,31,144,31,131,31,160,31,204,31,204,30,204,29,226,31,9,31,9,30,118,31,214,31,182,31,27,31,41,31,151,31,107,31,120,31,203,31,50,31,133,31,133,30,133,29,88,31,88,30,144,31,223,31,154,31,49,31,49,30,53,31,53,30,59,31,59,30,128,31,128,30,193,31,206,31,170,31,170,30,74,31,162,31,217,31,217,30,82,31,133,31,24,31,212,31,237,31,255,31,68,31,255,31,255,30,46,31,46,30,49,31,49,30,160,31,160,30,195,31,87,31,68,31,68,30,253,31,136,31,32,31,134,31,134,30,229,31,219,31,217,31,226,31,226,30,226,29,208,31,220,31,58,31,228,31,152,31,206,31,245,31,229,31,142,31,206,31,255,31,23,31,54,31,7,31,12,31,12,30,26,31,7,31,137,31,2,31,222,31,129,31,205,31,226,31,184,31,119,31,226,31,171,31,154,31,154,30,17,31,142,31,130,31,63,31,63,30,63,29,171,31,97,31,249,31,230,31,114,31,114,30,79,31,62,31,62,30,130,31,107,31,226,31,226,30,224,31,46,31,46,30,56,31,56,30,161,31,78,31,199,31,59,31,59,30,9,31,9,30,65,31,65,30,143,31,143,30,85,31,45,31,31,31,145,31,191,31,180,31,48,31,117,31,117,30,117,29,74,31,78,31,90,31,213,31,136,31,136,30,247,31,247,30,247,29,240,31,240,30,240,29,159,31,203,31,2,31,7,31,7,30,41,31,182,31,57,31,176,31,73,31,170,31,170,30,4,31,231,31,233,31,170,31,33,31,165,31,6,31,58,31,182,31,182,30,182,29,98,31,219,31,219,30,219,29,175,31,110,31,2,31,155,31,22,31,106,31,106,30,145,31,73,31,16,31,250,31,100,31,100,30,75,31,19,31,12,31,119,31,34,31,107,31,204,31,132,31,167,31,243,31,243,30,148,31,205,31,197,31,173,31,159,31,35,31,139,31,139,30,109,31,97,31,76,31,76,30,205,31,63,31,63,30,63,29,50,31,50,30,50,29,50,28,255,31,123,31,123,30,159,31,204,31,204,30,204,29,5,31,5,30,182,31,219,31,189,31,204,31,98,31,183,31,53,31,33,31,33,30,224,31,224,30,148,31,74,31,212,31,216,31,155,31,166,31,252,31,252,30,194,31,193,31,193,30,143,31,234,31,124,31,124,30,124,29,147,31,247,31,163,31,154,31,154,30,105,31,105,30,105,29,1,31,200,31,35,31,35,30,36,31,128,31,24,31,24,30,76,31,60,31,60,30,60,29,200,31,231,31,172,31,172,30,164,31,164,30,164,29,48,31,46,31,199,31,199,30,147,31,18,31,52,31,47,31,69,31,131,31,131,30,1,31,1,30,60,31,67,31,67,30,155,31,155,30,74,31,74,30,74,29,46,31,126,31,254,31,135,31,57,31,148,31,24,31,248,31,205,31,56,31,56,30,30,31,18,31,18,30,18,29,231,31,16,31);

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
